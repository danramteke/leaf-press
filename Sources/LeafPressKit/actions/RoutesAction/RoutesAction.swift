import Foundation
import NIO

public class RoutesAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func list() -> Result<[String], Error> {

    return Result {

      try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) -> EventLoopFuture<[String]> in
        return InternalRepresentationLoader(config: config)
          .load(threadPool: threadPool, eventLoopGroup: eventLoopGroup)
          .map { (website) -> [String] in
          website.pages.map({ $0.relativeUrl.path })
          +
          website.posts.map({ $0.relativeUrl.path })
        }
      }
    }
  }
}
