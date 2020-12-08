import Foundation
import PathKit
import NIO
import Yams

protocol InputFileInitable {
  init?(config: Config, inputFile: InputFile)
}

struct InputFile {
  let sha256: String
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

  var template: String? {
    frontMatter["template"]
  }
}

extension InputFile {
  init(string: String, at fileLocation: FileLocation) {
    let lines = string.components(separatedBy: "\n")

    if let idx = lines.firstIndex(where: { $0.hasPrefix("---") }) {
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

      self.init(sha256: string.sha256, frontMatter: frontMatter, source: fileLocation)
    } else {
      self.init(sha256: string.sha256, frontMatter: [:], source: fileLocation)
    }
  }
  init(buffer: ByteBuffer, at fileLocation: FileLocation) {
    self.init(string: String(buffer: buffer), at: fileLocation)
  }
}

