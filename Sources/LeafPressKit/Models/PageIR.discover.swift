import Foundation
import NIO

extension PageIR {
  static func discover(tree: FileTree, on eventLoop: EventLoop) -> EventLoopFuture<[PageIR.Id: PageIR]> {
    tree.fileLocations.map { location in
      
    }
    return eventLoop.makeSucceededFuture([:])
  }
}
