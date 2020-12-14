import Foundation
import PathKit


public struct FileLocation: Hashable, Codable {
  let root: String
  let directoryPath: String // relative path from root to file
  let rawFilename: String
  let slug: String // filename without extensions
  let fileExtension: String?

  init(root: String, directoryPath: String, slug: String, fileExtension: String?) {
    let rawFilename: String = {
      if let fileExtension = fileExtension {
        return slug + "." + fileExtension
      } else {
        return slug
      }
    }()
    self.init(root: root, directoryPath: directoryPath, rawFilename: rawFilename, slug: slug, fileExtension: fileExtension)
  }

  init(root: String, directoryPath: String, filename: String) {


    if let index = filename.firstIndex(of: ".") {
      let slug: String = filename[..<index].string
      let fileExtension: String = filename[filename.index(after: index)...].string

      self.init(root: root, directoryPath: directoryPath, rawFilename: filename, slug: slug, fileExtension: fileExtension)
    } else {
      self.init(root: root, directoryPath: directoryPath, rawFilename: filename, slug: filename, fileExtension: nil)
    }
  }

  private init(root: String, directoryPath: String, rawFilename: String, slug: String, fileExtension: String?) {
    self.root = root
    self.directoryPath = directoryPath
    self.rawFilename = rawFilename
    self.slug = slug
    self.fileExtension = fileExtension
  }

  init(path: Path, root: Path) {
    let filename = path.lastComponent


    let rootString = root.absolute().string
    let directoryPath = path.relative(to: root).string.removing(suffix: path.lastComponent)!

    self.init(root: rootString, directoryPath: directoryPath, filename: filename)
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
    Path(root) + Path(directoryPath) + Path(rawFilename)
  }

  var relativePath: Path {
    Path(directoryPath) + Path(rawFilename)
  }

  var relativeURL: URL {
    URL(string: "/" + relativePath.string)!
  }

  var datePrefix: String? {
    self.rawFilename.datePrefix
  }
}
