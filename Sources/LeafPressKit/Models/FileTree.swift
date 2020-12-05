import Foundation
import PathKit
import NIO

struct FileTree {
  let fileLocations: [FileLocation]
  init(fileLocations: [FileLocation]) {
    self.fileLocations = fileLocations
  }
}
