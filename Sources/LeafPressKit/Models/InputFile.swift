import Foundation
import PathKit
import NIO
import Yams
import LeafKit

protocol InputFileInitable {
  init(config: Config, inputFile: InputFile) throws
}

struct InputFile {
  let metadata: [String: LeafData]
  let source: FileLocation

  var slug: String {
    source.slug
  }

  var isIncluded: Bool {
    guard let draftString = metadata["draft"]?.string else {
      return true
    }

    guard let isDraft = Bool(draftString) else {
      return false
    }

    return !isDraft
  }

  var summary: String? {
    metadata["summary"]?.string
  }

  var dateString: DateString? {
    metadata["date"]?.string?.dateString
  }

  var title: String {
    metadata["title"]?.string ?? "Untitled"
  }

  var template: String? {
    metadata["template"]?.string
  }

  var category: String? {
    metadata["category"]?.string
  }
}

enum FrontmatterYamlParseError: Error, LocalizedError {
  case scalar, sequence, other(Error)
  var errorDescription: String? {
    switch self {
    case .scalar: return "Frontmatter should be a YAML dictionary, not a scalar"
    case .sequence: return "Frontmatter should be a YAML dictionary, not a sequence"
    case .other(let error): return "Error parsing metadata in frontmatter. \(error)"
    }
  }
}

extension InputFile {
  init(string: String, at fileLocation: FileLocation) throws {
    let metadata: [String: LeafData] = try {
      let pattern: String = #"---\n(.+)---\n(.+)$"#
      let regex = try NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
      let nsrange = NSRange(string.startIndex..<string.endIndex, in: string)

      guard let matchRange = regex.firstMatch(in: string, options: [], range: nsrange)?.range(at: 1) else {
        return [:]
      }

      guard matchRange.location != NSNotFound else {
        return [:]
      }

      guard let yamlRange = Range(matchRange, in: string) else {
        return [:]
      }


      let yamlDocument: String = string[yamlRange].string

      do {

        guard let node: Node = try Yams.compose(yaml: yamlDocument) else {
          return [:]
        }

        switch node {
        case .scalar:
          throw FrontmatterYamlParseError.scalar
        case .sequence:
          throw FrontmatterYamlParseError.sequence
        case .mapping(let mapping):
          return try mapping.asStringsToLeafData()
        }
      } catch {
        throw FrontmatterYamlParseError.other(error)
      }
    }()
    self.init(metadata: metadata, source: fileLocation)
  }
}


struct NonStringNodeKey: Error, LocalizedError {
  let errorDescription: String? = "Expect key of node to convert to a string easily"
}
