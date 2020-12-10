import Foundation

enum SupportedFileType: String, CaseIterable, Hashable {
  case md = "md", html = "html", leaf = "leaf"
}

struct UnsupportedFileType: Error, LocalizedError {
  let fileExtension: String

  var errorDescription: String? {
    self.fileExtension + "is not a supported file type."
  }
}
