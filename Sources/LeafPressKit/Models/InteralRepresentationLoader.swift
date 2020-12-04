import Foundation
import NIO

class InternalRepresentationLoader {

  let config: Config
  init(config: Config) {
    self.config = config
  }

  func load(pagesTree: FileTree, postsTree: FileTree, threadPool: NIOThreadPool, eventLoopGroup: EventLoopGroup) -> EventLoopFuture<Website> {

    let futurePosts: EventLoopFuture<[Post]> = self.loadRenderables(from: postsTree, in: threadPool, on: eventLoopGroup.next())
    let futurePages: EventLoopFuture<[Page]> = self.loadRenderables(from: pagesTree, in: threadPool, on: eventLoopGroup.next())


    return futurePages.and(futurePosts).map { (pages, posts) -> Website in
      Website(pages: pages, posts: posts)
    }
    
  }

  private func loadRenderables<T: InputFileInitable & Renderable>(from fileTree: FileTree, in threadPool: NIOThreadPool, on eventLoop: EventLoop) -> EventLoopFuture<[T]> {

    let things: [EventLoopFuture<T?>] = fileTree.load(in: threadPool, on: eventLoop).map { (inputFileFuture) in
      inputFileFuture.map { (inputFile) -> (T?) in
        T.init(config: self.config, inputFile: inputFile)
      }
    }

    return EventLoopFuture<T?>.whenAllComplete(things, on: eventLoop).map { (results) -> [T] in
      results.compactMap { (result) -> T? in
        switch result {
        case .success(let maybe): return maybe
        case .failure(let error):
          print(error)
          return nil
        }
      }
    }
  }
}
