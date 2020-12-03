import Foundation
import PathKit
import NIO

struct InputFile {

  //  let rawValue: String
  let frontMatter: [String: String]
  let source: FileLocation
  let target: FileLocation

  var fileType: FileType {
    source.fileType
  }

  var slug: String {
    source.slug
  }
  
  var summary: String? {
    frontMatter["summary"]
  }

  var published: DateString? {
    frontMatter["published"]?.dateString
  }

  var publishType: PublishType {
    source.publishType
  }
}

extension InputFile {
  init(string: String, at fileLocation: FileLocation) {
    let lines = string.components(separatedBy: "\n")

    if let idx = lines.firstIndex(of: "---") {
      let frontMatter = Dictionary<String, String>(uniqueKeysWithValues:
                                                    lines[lines.startIndex..<idx]
                                                    .compactMap { frontMatterLine in
                                                      if let colonIndex = frontMatterLine.firstIndex(of: ":") {
                                                        let key = frontMatterLine[..<colonIndex]
                                                        let val = frontMatterLine[frontMatterLine.index(colonIndex, offsetBy: 1)...]
                                                        return (String(key), val.trimmingCharacters(in: .whitespaces))
                                                      } else {
                                                        return nil
                                                      }
                                                    })

      print(frontMatter)
      self.init(frontMatter: frontMatter, source: fileLocation, target: fileLocation)
    } else {
      self.init(frontMatter: [:], source: fileLocation, target: fileLocation)
    }

  }
  init(buffer: ByteBuffer, at fileLocation: FileLocation) {
    self.init(string: String(buffer: buffer), at: fileLocation)
  }
}

protocol InputFileInitable {
  init?(inputFile: InputFile)
}
