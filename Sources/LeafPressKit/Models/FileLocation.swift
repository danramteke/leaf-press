import Foundation
import PathKit

enum PublishType: String, Codable {
  case page, post

  var templateName: String {
    switch self {
    case .page: return "page.leaf"
    case .post: return "post.leaf"
    }
  }
}

public struct FileLocation: Hashable, Codable {
  let root: String
  let directoryPath: String // relative path from root to file
  let slug: String // filename without extensions
  let fileType: FileType

  let publishType: PublishType

  init(root: String, directoryPath: String, slug: String, fileType: FileType, publishType: PublishType) {
    self.root = root
    self.directoryPath = directoryPath
    self.slug = slug
    self.fileType = fileType
    self.publishType = publishType
  }

  init?(path: Path, root: Path, publishType: PublishType) {
    let filename = path.lastComponent


    guard let fileType = FileType(filename: filename) else {
      return nil
    }

    let slug = filename.removing(suffix: fileType.rawValue)!
    let directoryPath = path.relative(to: root).string.removing(suffix: path.lastComponent)!

    self.init(root: root.absolute().string,
              directoryPath: directoryPath,
              slug: slug,
              fileType: fileType,
              publishType: publishType)
  }

  var absolutePath: Path {
    Path(root) + Path(directoryPath) + Path(slug + fileType.rawValue)
  }

  var relativePath: Path {
    Path(directoryPath) + Path(slug + fileType.rawValue)
  }

  var relativeURL: URL {
    URL(string: relativePath.string)!
  }
}


enum FileType: String, CaseIterable, Equatable, Hashable, Codable{
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
