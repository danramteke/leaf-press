import Foundation
import PathKit
import NIO
import Yams
import LeafKit

protocol InputFileInitable {
  init?(config: Config, inputFile: InputFile)
}

struct InputFile {
  let sha256: String
  let metadata: [String: LeafData]
  let source: FileLocation

  var fileType: FileType {
    source.fileType
  }

  var slug: String {
    source.slug
  }

  var summary: String? {
    metadata["summary"]?.string
  }

  var published: DateString? {
    metadata["published"]?.string?.dateString
  }

  var title: String? {
    metadata["title"]?.string
  }

  var template: String? {
    metadata["template"]?.string
  }
}

extension InputFile {
  init(string: String, at fileLocation: FileLocation) {
    let metadata: [String: LeafData] = {
      let lines = string.components(separatedBy: "\n")

      guard let idx = lines.firstIndex(where: { $0.hasPrefix("---") }) else {
        return [:]
      }

      let topOfDocument: String = lines[lines.startIndex..<idx].joined(separator: "\n")

      do {
        guard let yaml: [String: Any] = try Yams.load(yaml: topOfDocument) as? [String: Any] else {
          return [:]
        }

        return yaml.compactMapValues({ (any) -> LeafData? in
          (any as? LeafDataRepresentable)?.leafData
        })


      } catch {
        print("Error parsing metadata for \(fileLocation.absolutePath)", error)
        return [:]
      }
    }()
    self.init(sha256: string.sha256, metadata: metadata, source: fileLocation)
  }
}

