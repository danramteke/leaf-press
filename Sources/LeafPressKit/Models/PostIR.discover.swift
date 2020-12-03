import NIO
import Foundation

extension PostIR {
  static func discover(tree: FileTree, on eventLoop: EventLoop) -> EventLoopFuture<[PostIR.Id: PostIR]> {
    return eventLoop.makeSucceededFuture([:])
  }
}
