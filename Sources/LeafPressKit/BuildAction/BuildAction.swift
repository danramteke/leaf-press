import Foundation
import NIO

public class BuildAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func build(ignoreStatic: Bool) -> Result<Void, Error> {
    Result<Void, Error>.success(())
      .map { _ in
        CreateDirectoriesAction(config: config).start()
      }
      .flatMap { _ -> Result<Void, Error> in
        if ignoreStatic {
          return Result<Void, Error>.success(())
        } else {
          return CopyStaticFilesAction(source: config.staticFilesDir, target: config.distDir).start()
        }
      }
      .flatMap { _ in
        self.doBuild()
      }
  }

  private func doBuild2() -> Result<Void, Error> {
    let pagesTree = FileTree(root: self.config.pagesDir)
    let postsTree = FileTree(root: self.config.postsDir)

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 3)
    let threadPool = NIOThreadPool(numberOfThreads: 3)
    threadPool.start()

    let renderer = Renderer(config: config)
    let flag: EventLoopFuture<Void> = InternalRepresentationLoader(config: config)
      .load(pagesTree: pagesTree, postsTree: postsTree, threadPool: threadPool, eventLoopGroup: eventLoopGroup)
      .flatMap { (website)  in
        return renderer.render(website: website,
                               in: threadPool,
                               on: eventLoopGroup.next()).map { _ in
                                return ()
                               }
      }

    return Result<Void, Error> {
      try flag.wait()
      try eventLoopGroup.syncShutdownGracefully()
      try threadPool.syncShutdownGracefully()
    }
  }

  private func doBuild() -> Result<Void, Error> {

    let pagesTree = FileTree(root: self.config.pagesDir)
    let postsTree = FileTree(root: self.config.postsDir)

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 3)
    let eventLoop = eventLoopGroup.next()
    let threadPool = NIOThreadPool(numberOfThreads: 3)
    threadPool.start()

    let futurePosts: EventLoopFuture<[Post]> = self.loadRenderables(from: postsTree, in: threadPool, on: eventLoop)
    let futurePages: EventLoopFuture<[Page]> = self.loadRenderables(from: pagesTree, in: threadPool, on: eventLoop)

    let renderer = Renderer(config: config)

    let flag = futurePages.and(futurePosts).flatMap { (pages, posts) -> EventLoopFuture<Void> in

      let website = Website(pages: pages,
                            posts: posts)
      return renderer.render(website: website,
                             in: threadPool,
                             on: eventLoop)
    }

    return Result<Void, Error> {
      try flag.wait()
      try eventLoopGroup.syncShutdownGracefully()
      try threadPool.syncShutdownGracefully()
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
