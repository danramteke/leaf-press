import Foundation
import NIO
import PathKit

class InternalRepresentationLoader {

  let config: Config
  init(config: Config) {
    self.config = config
  }

  func load(threadPool: NIOThreadPool, eventLoopGroup: EventLoopGroup) -> EventLoopFuture<Website> {

    let futurePages: EventLoopFuture<[Page]> = loadRenderablesAt(root: self.config.pagesDir, eventLoopGroup: eventLoopGroup, threadPool: threadPool)
    let futurePosts: EventLoopFuture<[Post]> = loadRenderablesAt(root: self.config.postsDir, eventLoopGroup: eventLoopGroup, threadPool: threadPool)

    return futurePages.and(futurePosts).map { (pages, posts) -> Website in
      Website(pages: pages, posts: posts)
    }
  }

  private func loadRenderablesAt<T: Renderable & InputFileInitable>(root: Path, eventLoopGroup: EventLoopGroup, threadPool: NIOThreadPool) -> EventLoopFuture<[T]> {
    self.discoverFileTree(root: root, on: eventLoopGroup.next()).flatMap { tree in
      return self.loadRenderables(from: tree, in: threadPool, on: eventLoopGroup.next())
    }
  }

  private func discoverFileTree(root: Path, on eventLoop: EventLoop) -> EventLoopFuture<FileTree> {
    let promise = eventLoop.makePromise(of: FileTree.self)
    DispatchQueue.global().async {
      let fileLocations = root.glob(FileType.glob).compactMap { (childPath) -> FileLocation? in
        FileLocation(path: childPath.absolute(), root: root)
      }
      promise.succeed(FileTree(fileLocations: fileLocations))
    }
    return promise.futureResult
  }

  private func loadRenderables<T: InputFileInitable & Renderable>(from fileTree: FileTree, in threadPool: NIOThreadPool, on eventLoop: EventLoop) -> EventLoopFuture<[T]> {

    let files: [EventLoopFuture<T?>] = self.load(fileTree: fileTree, in: threadPool, on: eventLoop).map { (inputFileFuture) in
      inputFileFuture.map { (inputFile) -> (T?) in
        T.init(config: self.config, inputFile: inputFile)
      }
    }

    return EventLoopFuture<T?>.whenAllComplete(files, on: eventLoop).map { (results) -> [T] in
      results.compactMap { (result) -> T? in
        switch result {
        case .success(let maybe): return maybe
        case .failure(let error):
          print("***", error)
          return nil
        }
      }
    }
  }

  private func load(fileTree: FileTree, in threadPool: NIOThreadPool, on eventLoop: EventLoop) -> [EventLoopFuture<InputFile>] {
    let io = NonBlockingFileIO(threadPool: threadPool)

    return fileTree.fileLocations.map { (location) -> EventLoopFuture<InputFile> in
      location.read(with: io, on: eventLoop).map { (buffer) -> InputFile in
        return InputFile(buffer: buffer, at: location)
      }
    }
  }
}
