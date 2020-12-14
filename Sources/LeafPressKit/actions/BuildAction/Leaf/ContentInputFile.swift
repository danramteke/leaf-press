import Foundation

struct ContentInputFile {
  let sha256: String
  let content: String

  init(string: String) {
    self.sha256 = string.sha256
    let pattern: String = #"---\n(.+)---\n(.+)$"#
    let regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
    let nsrange = NSRange(string.startIndex..<string.endIndex, in: string)

    guard let matchRange = regex.firstMatch(in: string, options: [], range: nsrange)?.range(at: 2) else {
      self.content = string
      return
    }

    guard matchRange.location != NSNotFound else {
      self.content = string
      return
    }

    guard let contentRange = Range(matchRange, in: string) else {
      self.content = string
      return
    }

    self.content = string[contentRange].string
  }
}
