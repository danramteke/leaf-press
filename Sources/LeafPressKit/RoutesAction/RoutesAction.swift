import Foundation
import NIO

public class RoutesAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func list() -> Result<[String], Error> {
    let pagesTree = FileTree(root: self.config.pagesDir)
    let postsTree = FileTree(root: self.config.postsDir)


    return Result {

      try MultiThreadedContext().run { (eventLoopGroup, threadPool) -> EventLoopFuture<[String]> in
        InternalRepresentationLoader(config: config)
          .load(pagesTree: pagesTree, postsTree: postsTree, threadPool: threadPool, eventLoopGroup: eventLoopGroup)
          .map { (website) -> [String] in
          website.pages.map({ $0.relativeUrl.path })
          +
          website.posts.map({ $0.relativeUrl.path })
        }
      }
    }
  }
}
