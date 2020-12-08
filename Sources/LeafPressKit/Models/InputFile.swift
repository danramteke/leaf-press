import Foundation
import PathKit
import NIO
import Yams

protocol InputFileInitable {
  init?(config: Config, inputFile: InputFile)
}

struct InputFile {
  let sha256: String
  let metadata: [String: String]
  let source: FileLocation

  var fileType: FileType {
    source.fileType
  }

  var slug: String {
    source.slug
  }
  
  var summary: String? {
    metadata["summary"]
  }

  var published: DateString? {
    metadata["published"]?.dateString
  }

  var title: String? {
    metadata["title"]
  }

  var template: String? {
    metadata["template"]
  }
}

extension InputFile {
  init(string: String, at fileLocation: FileLocation) {
    let lines = string.components(separatedBy: "\n")

    if let idx = lines.firstIndex(where: { $0.hasPrefix("---") }) {
      let metadata = Dictionary<String, String>(uniqueKeysWithValues:
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

      self.init(sha256: string.sha256, metadata: metadata, source: fileLocation)
    } else {
      self.init(sha256: string.sha256, metadata: [:], source: fileLocation)
    }
  }
  init(buffer: ByteBuffer, at fileLocation: FileLocation) {
    self.init(string: String(buffer: buffer), at: fileLocation)
  }
}

