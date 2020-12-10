import Foundation

struct FileType: Equatable, Hashable, Codable {
  let rawValue: String
//  case md, leaf, html, other(String), none

  static let glob: String = "{*,*/*,**/*}"

  init(supportedFileType: SupportedFileType) {
    self.rawValue = supportedFileType.rawValue
  }

  init?(filename: String) {
    guard !filename.isEmpty else {
      return nil
    }
    guard let index = filename.firstIndex(of: ".") else {
      return nil
    }
    self.rawValue = String(filename[filename.index(after: index)...])
  }

  var supportedFileType: SupportedFileType? {
    SupportedFileType(rawValue: self.rawValue)
  }

  var dotted: String {
    "." + rawValue
  }


}
enum SupportedFileType: String, CaseIterable, Hashable {
  case md = "md", html = "html", leaf = "leaf"
}
extension Optional where Wrapped == FileType {
  var dotted: String {
    switch self {
    case .some(let fileType): return fileType.dotted
    case .none: return ""
    }
  }
}

struct UnsupportedFileType: Error, LocalizedError {
  let fileExtension: String

  var errorDescription: String? {
    self.fileExtension + "is not a supported file type."
  }
}
