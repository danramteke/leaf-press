import Foundation

struct ContentInputFile {
  let content: String

  init(string: String) {
    let lines = string.components(separatedBy: "\n")
    if let idx = lines.firstIndex(of: "---") {
      self.content = lines[idx.advanced(by: 1)...].joined(separator: "\n")
    } else {
      self.content = string
    }
  }
}
