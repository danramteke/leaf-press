import LeafKit
import Foundation
import NIO

class InMemoryLeafSource: LeafSource {
  var memory: [String: String] = .init()
  func file(template: String, escape: Bool, on eventLoop: EventLoop) throws -> EventLoopFuture<ByteBuffer> {
    if let string = memory[template] {
      return eventLoop.makeSucceededFuture(ByteBuffer(string: string))
    } else {
      return eventLoop.makeFailedFuture(NotFoundError())
    }
  }

  struct NotFoundError: Error { }

  func register(content: String, at path: String) {
    memory[path] = content
  }

  func removeContent(at path: String) {
    memory[path] = nil
  }
}
