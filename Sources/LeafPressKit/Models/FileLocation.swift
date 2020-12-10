import Foundation
import PathKit


public struct FileLocation: Hashable, Codable {
  let root: String
  let directoryPath: String // relative path from root to file
  let rawFilename: String
  let slug: String // filename without extensions
  let fileExtension: String?
//  let fileType: FileType?

  init(root: String, directoryPath: String, rawFilename: String, slug: String, fileExtension: String?) {
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

    if let index = filename.firstIndex(of: ".") {
      let slug: String = filename[..<index].string
      let fileExtension: String = filename[filename.index(after: index)...].string


      self.init(root: rootString, directoryPath: directoryPath, rawFilename: filename, slug: slug, fileExtension: fileExtension)
    } else {
      self.init(root: rootString, directoryPath: directoryPath, rawFilename: filename, slug: filename, fileExtension: nil)
    }

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
    guard let range = self.rawFilename.range(of: #"^\d\d\d\d-\d\d-\d\d-"#, options: .regularExpression) else {
      return nil
    }

    return self.rawFilename[range].string
  }
}
