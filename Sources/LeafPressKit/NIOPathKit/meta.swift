import Foundation
import PathKit
import NIO

extension Path {
  func isDirectoryAsync(eventLoop: EventLoop) -> EventLoopFuture<Bool> {
    let promise = eventLoop.makePromise(of: Bool.self)
    DispatchQueue.global().async {
      promise.succeed(self.isDirectory)
    }
    return promise.futureResult
  }

  func existsAsync(eventLoop: EventLoop) -> EventLoopFuture<Bool> {
    let promise = eventLoop.makePromise(of: Bool.self)
    DispatchQueue.global().async {
      promise.succeed(self.exists)
    }
    return promise.futureResult
  }
}
