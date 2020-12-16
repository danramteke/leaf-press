import Foundation
import NIO
import PathKit

extension Path {
  public func recursiveChildrenAsync(eventLoop: EventLoop) -> EventLoopFuture<[Path]> {
    let promise = eventLoop.makePromise(of: [Path].self)
    DispatchQueue.global().async {
      do {
        guard self.exists else {
          promise.succeed([])
          return
        }
        let children = try self.recursiveChildren()
        promise.succeed(children)
      } catch {
        promise.fail(error)
      }

    }
    return promise.futureResult
  }
}
