import Foundation
import MPath

public struct FileLocation: Hashable {
  let root: Path
  let directoryPath: Path // relative path from root to file
  let rawFilename: String
  let datePrefix: DatePrefix?
  let slug: String // filename without extensions
  let fileExtension: String?

  init(root: Path, directoryPath: Path, slug: String, fileExtension: String?) {
    let rawFilename: String = {
      if let fileExtension = fileExtension {
        return slug + "." + fileExtension
      } else {
        return slug
      }
    }()
    self.init(root: root, directoryPath: directoryPath, rawFilename: rawFilename, datePrefix: nil, slug: slug, fileExtension: fileExtension)
  }

  init(root: Path, directoryPath: Path, filename: String) {
    if let index = filename.lastIndex(of: ".") {
      let slug: String = filename[..<index].string
      let fileExtension: String = filename[filename.index(after: index)...].string

      if let datePrefix = DatePrefix(filename: slug) {
        let slug = slug[datePrefix.originalRange.upperBound...].string
        self.init(root: root, directoryPath: directoryPath, rawFilename: filename, datePrefix: datePrefix, slug: slug, fileExtension: fileExtension)
      } else {
        self.init(root: root, directoryPath: directoryPath, rawFilename: filename, datePrefix: nil, slug: slug, fileExtension: fileExtension)
      }


    } else {
      self.init(root: root, directoryPath: directoryPath, rawFilename: filename, datePrefix: nil, slug: filename, fileExtension: nil)
    }
  }

  private init(root: Path, directoryPath: Path, rawFilename: String, datePrefix: DatePrefix?, slug: String, fileExtension: String?) {
    self.root = root
    self.directoryPath = directoryPath
    self.rawFilename = rawFilename
    self.datePrefix = datePrefix
    self.slug = slug
    self.fileExtension = fileExtension
  }

  init(path: Path, root: Path) {
    let filename = path.components.last ?? ""


    let absoluteRoot = root.absolute()
    let directoryPath = Path(path.relative(to: root).string.removing(suffix: filename)!)

    self.init(root: absoluteRoot, directoryPath: directoryPath, filename: filename)
  }

  var supportedFileType: SupportedFileType? {
    guard let fileExtension = fileExtension else {
      return nil
    }

    guard let supportedFileType = SupportedFileType(rawValue: fileExtension) else {
      return nil
    }

    return supportedFileType
  }

  var absolutePath: Path {
    root + directoryPath + Path(rawFilename)
  }

  var relativePath: Path {
    directoryPath + Path(rawFilename)
  }

  var relativeURL: URL {
    URL(string: "/" + relativePath.string)!
  }
}
