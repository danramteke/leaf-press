import Foundation
import PathKit

struct InputFile {
  let rawValue: String

  let source: FileLocation
  let target: FileLocation
  let published: DateString
  let summary: String
  let root: String


}

struct FileLocation {
  let relativePath: String // relative path from root to file
  let slug: String // filename without extensions
  let fileType: FileType

  init(relativePath: String, slug: String, fileType: FileType) {
    self.relativePath = relativePath
    self.slug = slug
    self.fileType = fileType
  }

  init?(path: Path, root: Path) {
    let filename = path.lastComponent


    guard let fileType = FileType(filename: filename) else {
      return nil
    }

    let slug = filename.removing(suffix: fileType.rawValue)!
    let relativePath = path.relative(to: root).string

    self.init(relativePath: relativePath,
              slug: slug,
              fileType: fileType)
  }
}

enum FileType: String, CaseIterable {
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


extension String {
  public func removing(suffix: String) -> String? {
    guard self.hasSuffix(suffix) else { return nil }
    if let range = self.range(of: suffix) {
      let slice = self[..<range.lowerBound]
      return String(slice)
    } else {
      return nil
    }
  }
}
