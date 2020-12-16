import Foundation
import LeafKit
import Yams

class InputFileParser {

  func metadata(from string: String) throws -> [String: LeafData] {
    guard let yamlDocument = self.match(string: string, at: 1) else {
      return [:]
    }

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
  }

  func content(from string: String) -> String {
    guard let content = self.match(string: string, at: 2) else {
      return string
    }
    return content
  }

  let regex = try! NSRegularExpression(pattern: #"---\n(.+)---\n(.+)$"#, options: [.dotMatchesLineSeparators])

  private func match(string: String, at index: Int) -> String? {
    guard let matchRange = regex.firstMatch(in: string, options: [], range: string.nsrange)?.range(at: index) else {
      return nil
    }

    guard matchRange.location != NSNotFound else {
      return nil
    }

    guard let contentRange = Range(matchRange, in: string) else {
      return nil
    }

    return string[contentRange].string
  }
}

enum FrontmatterYamlParseError: Error, LocalizedError {
  case scalar, sequence, other(Error), nonStringNodeKey
  var errorDescription: String? {
    switch self {
    case .scalar: return "Frontmatter should be a YAML dictionary, not a scalar"
    case .sequence: return "Frontmatter should be a YAML dictionary, not a sequence"
    case .other(let error): return "Error parsing metadata in frontmatter. \(error)"
    case .nonStringNodeKey: return "Expected key of node to convert to a string"
    }
  }
}
