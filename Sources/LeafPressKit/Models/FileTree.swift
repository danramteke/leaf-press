import Foundation
import MPath
import NIO

struct FileTree {

  let renderable: [FileLocation]
  let copyable: [FileLocation]

  init(fileLocations: [FileLocation]) {


    let grouped = Dictionary(grouping: fileLocations) { (fileLocation) -> String in
      nil == fileLocation.supportedFileType ? "copyable" : "renderable"
    }

    self.renderable = grouped["renderable"] ?? []
    self.copyable = grouped["copyable"] ?? []

  }
  init(renderable: [FileLocation], copyable: [FileLocation]) {
    self.renderable = renderable
    self.copyable = copyable
  }
}
