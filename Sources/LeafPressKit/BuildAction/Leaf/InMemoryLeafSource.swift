import LeafKit
import Foundation
import NIO
import NIOConcurrencyHelpers

class InMemoryLeafSource: LeafSource {
  private let lock = Lock()
  var memory: [String: String] = .init()
  func file(template: String, escape: Bool, on eventLoop: EventLoop) throws -> EventLoopFuture<ByteBuffer> {
    self.lock.withLock {
      if let string = memory[template] {
        return eventLoop.makeSucceededFuture(ByteBuffer(string: string))
      } else {
        return eventLoop.makeFailedFuture(NotFoundError())
      }
    }
  }

  struct NotFoundError: Error { }

  func register(content: String, at path: String) {
    self.lock.withLock {
      memory[path] = content
    }
  }

  func removeContent(at path: String) {
    self.lock.withLock {
      memory[path] = nil
    }
  }
}
