import Foundation
import PathKit

class FileTree {
  let fileLocations: [FileLocation]
  init(root: Path, publishType: PublishType) {
    self.fileLocations = root.glob(FileType.glob).compactMap { (childPath) -> FileLocation? in
      FileLocation(path: childPath.absolute(), root: root, publishType: publishType)
    }
  }
}
