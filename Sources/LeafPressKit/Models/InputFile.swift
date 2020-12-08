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
    let metadata: [String: String] = {
      let lines = string.components(separatedBy: "\n")

      guard let idx = lines.firstIndex(where: { $0.hasPrefix("---") }) else {
        return [:]
      }

      let topOfDocument: String = lines[lines.startIndex..<idx].joined(separator: "\n")

      do {
        let yaml: [String: String]? = try Yams.load(yaml: topOfDocument) as? [String: String]
        return yaml ?? [:]
      } catch {
        print("Error parsing metadata for \(fileLocation.absolutePath)", error)
        return [:]
      }
    }()
    self.init(sha256: string.sha256, metadata: metadata, source: fileLocation)
  }
}

