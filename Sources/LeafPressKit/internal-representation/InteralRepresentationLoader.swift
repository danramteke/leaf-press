import Foundation
import NIO
import MPath
typealias WebsiteRenderResult = (Website, [Error])

class InternalRepresentationLoader {

  let config: Config
  let includeDrafts: Bool
  let includeStatic: Bool
  init(config: Config, includeDrafts: Bool, includeStatic: Bool) {
    self.config = config
    self.includeDrafts = includeDrafts
    self.includeStatic = includeStatic
  }

  func load(threadPool: NIOThreadPool, eventLoopGroup: EventLoopGroup) -> EventLoopFuture<(Website, [Error])> {

    let futureMaybePagesTree: EventLoopFuture<FileTree?> = self.discoverFileTreeAt(root: self.config.pagesDir, eventLoopGroup: eventLoopGroup)
    let futureMaybePostsTree: EventLoopFuture<FileTree?> = self.discoverFileTreeAt(root: self.config.postsDir, eventLoopGroup: eventLoopGroup)
    let futureMaybeStaticsTree: EventLoopFuture<FileTree?> = self.discoverFileTreeAt(root: self.config.staticFilesDir, assumeAllStatic: true, eventLoopGroup: eventLoopGroup)

    let futurePagesStatics: EventLoopFuture<[StaticFile]> = self.discoverStaticFiles(from: futureMaybePagesTree, on: eventLoopGroup)
    let futurePostsStatics: EventLoopFuture<[StaticFile]> = self.discoverStaticFiles(from: futureMaybePostsTree, prefix: self.config.postsPublishPrefix, on: eventLoopGroup)
    let futureStaticFiles: EventLoopFuture<[StaticFile]> = self.discoverStaticFiles(from: futureMaybeStaticsTree, on: eventLoopGroup)

    let futurePages: EventLoopFuture<[Result<Page, Error>]> = self.loadRenderables(from: futureMaybePagesTree, in: threadPool, on: eventLoopGroup)
    let futurePosts: EventLoopFuture<[Result<Post, Error>]> = self.loadRenderables(from: futureMaybePostsTree, in: threadPool, on: eventLoopGroup)

    let futureCombinedStatics: EventLoopFuture<[StaticFile]> = EventLoopFuture<([StaticFile], [StaticFile], [StaticFile])>.multiWait(futurePagesStatics, futurePostsStatics, futureStaticFiles).map { arg0 -> [StaticFile] in
      return arg0.0 + arg0.1 + arg0.2
    }

    return EventLoopFuture<Any>.multiWait(futurePages, futurePosts, futureCombinedStatics).map { (arg0) -> (Website, [Error]) in
      let (pageResults, postResults, statics) = arg0

      var errors: [Error] = []
      var pages: [Page] = []
      var posts: [Post] = []

      pageResults.forEach {
        switch $0 {
        case .failure(let error):
          errors.append(error)
        case .success(let page):
          if page.isIncluded || self.includeDrafts {
            pages.append(page)
          }
        }
      }

      postResults.forEach {
        switch $0 {
        case .failure(let error):
          errors.append(error)
        case .success(let post):
          if post.isIncluded || self.includeDrafts {
            posts.append(post)
          }
        }
      }

      return (Website(pages: pages, posts: posts, staticFiles: statics), errors)
    }
  }

  private func discoverFileTreeAt(root: Path, assumeAllStatic: Bool = false, eventLoopGroup: EventLoopGroup) -> EventLoopFuture<FileTree?> {
    return root.existsAsync(eventLoop: eventLoopGroup.next()).flatMap { exists -> EventLoopFuture<FileTree?> in
      guard exists else {
        return eventLoopGroup.next().makeSucceededFuture(nil)
      }
      let promise = eventLoopGroup.next().makePromise(of: FileTree.self)
      DispatchQueue.global().async {
        do {
          let fileLocations = try root.recursiveChildren().compactMap { (childPath) -> FileLocation? in
            guard childPath.isFile else {
              return nil
            }
            return FileLocation(path: childPath.absolute(), root: root)
          }

          if assumeAllStatic {
            promise.succeed(FileTree(renderable: [], copyable: fileLocations))
          } else {
            promise.succeed(FileTree(fileLocations: fileLocations))
          }

        } catch {
          promise.fail(error)
        }
      }
      return promise.futureResult.map({ $0 })
    }
  }


  private func loadRenderables<T: InputFileInitable & Renderable>(from futureMaybeFileTree: EventLoopFuture<FileTree?>, in threadPool: NIOThreadPool, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<[Result<T, Error>]> {

    return futureMaybeFileTree.flatMap { maybeFileTree in
      guard let fileTree = maybeFileTree else {
        return eventLoopGroup.next().makeSucceededFuture([])
      }

      let renderFutures: [EventLoopFuture<Result<T, Error>>] = self.load(fileTree: fileTree, in: threadPool, on: eventLoopGroup).map { (inputFileFuture) in
        inputFileFuture.map { inputFile -> Result<T, Error> in
          Result {
            try T.init(config: self.config, inputFile: inputFile)
          }
        }
      }

      return EventLoopFuture.whenAllComplete(renderFutures, on: eventLoopGroup.next()).map { $0.map { $0.flatMap { $0 } } }
    }
  }



  private func discoverStaticFiles(from futureMaybeFileTree: EventLoopFuture<FileTree?>, prefix: Path? = nil, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<[StaticFile]> {
    return futureMaybeFileTree.map { maybeFileTree -> [StaticFile] in
      guard self.includeStatic, let fileTree = maybeFileTree else {
        return []
      }

      return fileTree.copyable.map { source -> StaticFile in

        let directoryPath: Path = [prefix, source.directoryPath].compactMap({$0}).reduce(Path(), +)
        let target = FileLocation(root: self.config.distDir, directoryPath: directoryPath, filename: source.rawFilename)

        return StaticFile(slug: source.slug, source: source, target: target, relativeUrl: target.relativeURL)
      }
    }
  }

  private func load(fileTree: FileTree, in threadPool: NIOThreadPool, on eventLoopGroup: EventLoopGroup) -> [EventLoopFuture<InputFileMetadata>] {
    let io = NonBlockingFileIO(threadPool: threadPool)

    return fileTree.renderable
      .map { location -> EventLoopFuture<InputFileMetadata> in
        return location
          .read(with: io, on: eventLoopGroup.next())
          .flatMap { byteBuffer -> EventLoopFuture<InputFileMetadata> in
            do {
              let inputFile = try InputFileMetadata(string: String(buffer: byteBuffer), at: location)
              return eventLoopGroup.next().makeSucceededFuture(inputFile)
            } catch {
              return eventLoopGroup.next().makeFailedFuture(error)
            }
          }
      }
  }
}
