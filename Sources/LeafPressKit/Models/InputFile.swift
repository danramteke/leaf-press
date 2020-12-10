import Foundation
import PathKit
import NIO
import Yams
import LeafKit

protocol InputFileInitable {
  init(config: Config, inputFile: InputFile) throws
}

struct InputFile {
  let sha256: String
  let metadata: [String: LeafData]
  let source: FileLocation

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

enum FrontmatterYamlParseError: String, Error, LocalizedError {
  case scalar, sequence
  var errorDescription: String? { "Frontmatter should be a YAML dictionary, not a \(self.rawValue)" }
}

extension InputFile {
  init(string: String, at fileLocation: FileLocation) throws {
    let metadata: [String: LeafData] = {
      let lines = string.components(separatedBy: "\n")

      guard let idx = lines.firstIndex(where: { $0.hasPrefix("---") }) else {
        return [:]
      }

      let topOfDocument: String = lines[lines.startIndex..<idx].joined(separator: "\n")

      do {

        guard let node: Node = try Yams.compose(yaml: topOfDocument) else {
          return [:]
        }

        switch node {
        case .scalar:
          throw FrontmatterYamlParseError.scalar
        case .sequence:
          throw FrontmatterYamlParseError.sequence
        case .mapping(let mapping):
          let pairs: [(String, LeafData)] = try mapping.keys.map { (key) in
            (key.string!, try mapping[key]!.leafData())
          }
          return Dictionary(uniqueKeysWithValues: pairs)
        }

      } catch {
        print("Error parsing metadata for \(fileLocation.absolutePath)", error)
        return [:]
      }
    }()
    self.init(sha256: string.sha256, metadata: metadata, source: fileLocation)
  }
}

struct NonStringNodeKey: Error, LocalizedError {
  let errorDescription: String? = "Expect key of node to convert to a string easily"
}
