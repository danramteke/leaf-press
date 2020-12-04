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
      .flatMap { _  -> Result<Void, Error> in
        if ignoreStatic {
          return .success(())
        } else {
          return CopyStaticFilesAction(source: config.staticFilesDir, target: config.distDir).start()
        }
      }
      .flatMap { _ in
        self.doBuild()
      }
  }

  private func doBuild() -> Result<Void, Error> {

    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 3)
    let eventLoop = eventLoopGroup.next()
    let threadPool = NIOThreadPool(numberOfThreads: 3)
    threadPool.start()

    let pagesTree = FileTree(root: self.config.pagesDir, publishType: .page)
    let postsTree = FileTree(root: self.config.postsDir, publishType: .post)


    let pagesInputFiles = pagesTree.load(in: threadPool, on: eventLoop)
    let postsInputFiles = postsTree.load(in: threadPool, on: eventLoop)

    let futurePageIRs = pagesInputFiles.map { (inputFileFuture) -> EventLoopFuture<Page?> in
      inputFileFuture.map { (inputFile) -> (Page?) in
        Page(config: self.config, inputFile: inputFile)
      }
    }
    let futurePostIRs = postsInputFiles.map { (inputFileFuture) -> EventLoopFuture<Post?> in
      inputFileFuture.map { (inputFile) -> (Post?) in
        Post(config: self.config, inputFile: inputFile)
      }
    }

    let futurePages: EventLoopFuture<[Page]> = EventLoopFuture<Page?>.whenAllComplete(futurePageIRs, on: eventLoop).map { (results) -> [Page] in
      results.compactMap { (result) -> Page? in
        switch result {
        case .success(let maybe): return maybe
        case .failure(let error):
          print(error)
          return nil
        }
      }
    }

    let futurePosts: EventLoopFuture<[Post]> = EventLoopFuture<Post?>.whenAllComplete(futurePostIRs, on: eventLoop).map { (results) -> [Post] in
      results.compactMap { (result) -> Post? in
        switch result {
        case .success(let maybe): return maybe
        case .failure(let error):
          print(error)
          return nil
        }
      }
    }

    let renderer = Renderer(config: config)

    let flag = futurePages.and(futurePosts).flatMap { (pages, posts ) -> EventLoopFuture<Void> in

      let website = Website(pages: pages,
                            posts: posts)
      return renderer.render(website: website,
                             in: threadPool,
                             on: eventLoop)
    }


    do {
      try flag.wait()
      try eventLoopGroup.syncShutdownGracefully()
      try threadPool.syncShutdownGracefully()
    }
    catch {
      return .failure(error)
    }
    return .success(())
  }
}
