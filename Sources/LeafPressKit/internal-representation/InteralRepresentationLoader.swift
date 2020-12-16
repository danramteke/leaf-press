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

    let futurePages: EventLoopFuture<[Result<Page, Error>]> = loadRenderablesAt(root: self.config.pagesDir, eventLoopGroup: eventLoopGroup, threadPool: threadPool)
    let futurePosts: EventLoopFuture<[Result<Post, Error>]> = loadRenderablesAt(root: self.config.postsDir, eventLoopGroup: eventLoopGroup, threadPool: threadPool)

    return futurePages.and(futurePosts).map { (pageResults, postResults) -> (Website, [Error]) in
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

      return (Website(pages: pages, posts: posts), errors)
    }
  }

  private func loadRenderablesAt<T: Renderable & InputFileInitable>(root: Path, eventLoopGroup: EventLoopGroup, threadPool: NIOThreadPool) -> EventLoopFuture<[Result<T, Error>]> {
    return root.existsAsync(eventLoop: eventLoopGroup.next()).flatMap { (exists) in
      guard exists else {
        return eventLoopGroup.next().makeSucceededFuture([])
      }
      return self.discoverFileTree(root: root, on: eventLoopGroup.next()).flatMap { tree in
        return self.loadRenderables(from: tree, in: threadPool, on: eventLoopGroup)
      }
    }

  }

  private func discoverFileTree(root: Path, on eventLoop: EventLoop) -> EventLoopFuture<FileTree> {
    let promise = eventLoop.makePromise(of: FileTree.self)
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
    return promise.futureResult
  }

  private func loadRenderables<T: InputFileInitable & Renderable>(from fileTree: FileTree, in threadPool: NIOThreadPool, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<[Result<T, Error>]> {

    let files: [EventLoopFuture<Result<T, Error>>] = self.load(fileTree: fileTree, in: threadPool, on: eventLoopGroup).map { (inputFileFuture) in
      inputFileFuture.map { inputFile -> Result<T, Error> in
        Result {
          try T.init(config: self.config, inputFile: inputFile)
        }
      }
    }

    return EventLoopFuture.whenAllComplete(files, on: eventLoopGroup.next()).map { $0.map { $0.flatMap { $0 } } }
  }

  private func load(fileTree: FileTree, in threadPool: NIOThreadPool, on eventLoopGroup: EventLoopGroup) -> [EventLoopFuture<InputFileMetadata>] {
    let io = NonBlockingFileIO(threadPool: threadPool)

    return fileTree.fileLocations
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
