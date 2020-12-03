import Foundation
import NIO
extension WebsiteIR {
  func render(on eventLoop: EventLoop) -> EventLoopFuture<Void> {
    return eventLoop.makeSucceededFuture(())
  }
}
