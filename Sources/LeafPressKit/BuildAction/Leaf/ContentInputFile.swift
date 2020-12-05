import Foundation

struct ContentInputFile {
  let sha256: String
  let content: String

  init(string: String) {
    self.sha256 = string.sha256
    let lines = string.components(separatedBy: "\n")
    if let idx = lines.firstIndex(of: "---") {
      self.content = lines[idx.advanced(by: 1)...].joined(separator: "\n")
    } else {
      self.content = string
    }
  }
}
