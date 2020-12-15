import PathKit
import NIO
import Foundation

extension Path {
  public func appending(_ string: String?, default: Path) -> Path {
    if let string = string {
      return self + Path(string)
    } else {
      return self + `default`
    }
  }

  public func relative(to parent: Path) -> Path {
    var meAbs = self.absolute().string
    let parentsAbs = parent.absolute().string

    guard meAbs.starts(with: parentsAbs) else {
      return self
    }

    meAbs.removeSubrange(...parentsAbs.endIndex)

    return Path(meAbs)
  }

  func makePathAsync(eventLoop: EventLoop) -> EventLoopFuture<Void> {
    let promise = eventLoop.makePromise(of: Void.self)
    DispatchQueue.global().async {
      do {
      try self.mkpath()
        promise.succeed(())
      } catch {
        promise.fail(error)
      }

    }
    return promise.futureResult
  }

}
