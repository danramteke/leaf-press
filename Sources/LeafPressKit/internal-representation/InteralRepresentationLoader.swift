import Foundation
import NIO
import PathKit
typealias WebsiteRenderResult = (Website, [Error])

class InternalRepresentationLoader {

  let config: Config
  let includeDrafts: Bool
  init(config: Config, includeDrafts: Bool) {
    self.config = config
    self.includeDrafts = includeDrafts
  }

  func load(threadPool: NIOThreadPool, eventLoopGroup: EventLoopGroup) -> EventLoopFuture<(Website, [Error])> {

    let futureMaybePagesTree: EventLoopFuture<FileTree?> = self.discoverFileTreeAt(root: self.config.pagesDir, eventLoopGroup: eventLoopGroup, threadPool: threadPool)
    let futureMaybePostsTree: EventLoopFuture<FileTree?> = self.discoverFileTreeAt(root: self.config.postsDir, eventLoopGroup: eventLoopGroup, threadPool: threadPool)

    let futurePagesStatics: EventLoopFuture<[StaticFile]> = self.discoverStaticFiles(from: futureMaybePagesTree, copyingToRoot: self.config.distDir, on: eventLoopGroup)
    let futurePostsStatics: EventLoopFuture<[StaticFile]> = self.discoverStaticFiles(from: futureMaybePostsTree, copyingToRoot: self.config.postsPublishDir, on: eventLoopGroup)

    let futurePages: EventLoopFuture<[Result<Page, Error>]> = self.loadRenderables(from: futureMaybePagesTree, in: threadPool, on: eventLoopGroup)
    let futurePosts: EventLoopFuture<[Result<Post, Error>]> = self.loadRenderables(from: futureMaybePostsTree, in: threadPool, on: eventLoopGroup)

    let staticFutures = futurePagesStatics.and(futurePostsStatics).map { (left, right) -> [StaticFile] in
      return left + right
    }

    let nonStaticFutures = futurePages.and(futurePosts)

    return nonStaticFutures.and(staticFutures).map { (nonStatics, statics) -> (Website, [Error]) in
      let pageResults = nonStatics.0
      let postResults = nonStatics.1
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

  private func discoverFileTreeAt(root: Path, eventLoopGroup: EventLoopGroup, threadPool: NIOThreadPool) -> EventLoopFuture<FileTree?> {
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
          promise.succeed(FileTree(fileLocations: fileLocations))
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



  private func discoverStaticFiles(from futureMaybeFileTree: EventLoopFuture<FileTree?>, copyingToRoot: Path, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<[StaticFile]> {
    return futureMaybeFileTree.map { maybeFileTree -> [StaticFile] in
      guard let fileTree = maybeFileTree else {
        return []
      }

      return fileTree.copyable.map { source -> StaticFile in

        let target = FileLocation(root: copyingToRoot.absolute().string, directoryPath: source.directoryPath, filename: source.rawFilename)

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
