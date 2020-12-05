import Foundation
import PathKit


public struct FileLocation: Hashable, Codable {
  let root: String
  let directoryPath: String // relative path from root to file
  let slug: String // filename without extensions
  let fileType: FileType

  init(root: String, directoryPath: String, slug: String, fileType: FileType) {
    self.root = root
    self.directoryPath = directoryPath
    self.slug = slug
    self.fileType = fileType
  }

  init?(path: Path, root: Path) {
    let filename = path.lastComponent


    guard let fileType = FileType(filename: filename) else {
      return nil
    }

    let slug = filename.removing(suffix: fileType.rawValue)!
    let directoryPath = path.relative(to: root).string.removing(suffix: path.lastComponent)!

    self.init(root: root.absolute().string,
              directoryPath: directoryPath,
              slug: slug,
              fileType: fileType)
  }

  var absolutePath: Path {
    Path(root) + Path(directoryPath) + Path(slug + fileType.rawValue)
  }

  var relativePath: Path {
    Path(directoryPath) + Path(slug + fileType.rawValue)
  }

  var relativeURL: URL {
    URL(string: "/" + relativePath.string)!
  }
}
