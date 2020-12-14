import Foundation
import NIO

public class RoutesAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func list(includeDrafts: Bool) -> Result<([String], [Error]), Error> {

    return Result {

      try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) -> EventLoopFuture<([String], [Error])> in
        return InternalRepresentationLoader(config: config, includeDrafts: includeDrafts)
          .load(threadPool: threadPool, eventLoopGroup: eventLoopGroup)
          .map { (website, errors) -> ([String], [Error]) in
            (website.routes, errors)
        }
      }
    }
  }


}

private extension Website {
  var routes: [String] {
    self.pages.map({ $0.relativeUrl.path }) + self.posts.map({ $0.relativeUrl.path })
  }
}
