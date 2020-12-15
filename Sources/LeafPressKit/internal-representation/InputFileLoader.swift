import Foundation
import LeafKit
import Yams

class InputFileParser {
  private let pattern: String = #"---\n(.+)---\n(.+)$"#
  lazy var regex = try! NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators])
  func content(from string: String) -> String {

    let nsrange = NSRange(string.startIndex..<string.endIndex, in: string)

    guard let matchRange = regex.firstMatch(in: string, options: [], range: nsrange)?.range(at: 2) else {
      return string
    }

    guard matchRange.location != NSNotFound else {
      return string
    }

    guard let contentRange = Range(matchRange, in: string) else {
      return string
    }

    return string[contentRange].string
  }

  func metadata(from string: String) throws -> [String: LeafData] {
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
