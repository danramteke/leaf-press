import Foundation

enum FileType: String, CaseIterable, Equatable, Hashable, Codable {
  case mdLeaf = ".md.leaf"
  case md = ".md", leaf = ".leaf", html = ".html"

  static let glob: String = "*.{md,html,leaf}"

  init?(filename: String) {
    let maybeFileType = FileType.allCases.first(where: { fileType in
      filename.hasSuffix(fileType.rawValue)
    })

    guard let fileType = maybeFileType else {
      return nil
    }
    self = fileType
  }
}
