import Foundation
import PathKit
import NIO

class FileTree {
  let fileLocations: [FileLocation]
  init(root: Path) {
    self.fileLocations = root.glob(FileType.glob).compactMap { (childPath) -> FileLocation? in
        FileLocation(path: childPath.absolute(), root: root)
    }
  }

//  func buildInternalRepresentation() -> EventLoopFuture<Void> {
//    return .
//  }
}
