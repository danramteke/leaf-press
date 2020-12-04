import Foundation
import PathKit
import NIO

struct ContentInputFile {
  let content: String

  init(string: String) {
    let lines = string.components(separatedBy: "\n")
    if let idx = lines.firstIndex(of: "---") {
      self.content = lines[idx...].joined(separator: "\n")
    } else {
      self.content = string
    }
  }
}

struct InputFile {
  //  let rawValue: String
  let frontMatter: [String: String]
  let source: FileLocation

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

  var title: String? {
    frontMatter["title"]
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
                                                      guard let colonIndex = frontMatterLine.firstIndex(of: ":") else {
                                                        return nil
                                                      }
                                                      let key = frontMatterLine[..<colonIndex].string
                                                      let val = frontMatterLine[frontMatterLine.index(colonIndex, offsetBy: 1)...]
                                                        .trimmingCharacters(in: .whitespaces)

                                                      return (key, val)
                                                    })

      self.init(frontMatter: frontMatter, source: fileLocation)
    } else {
      self.init(frontMatter: [:], source: fileLocation)
    }

  }
  init(buffer: ByteBuffer, at fileLocation: FileLocation) {
    self.init(string: String(buffer: buffer), at: fileLocation)
  }
}

