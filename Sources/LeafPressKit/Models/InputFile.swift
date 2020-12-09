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

        guard let node: Node = try Yams.compose(yaml: topOfDocument) else {
          return [:]
        }

        switch node {

        case .scalar(let scaler):
          print("got \(scaler), expected mapping")
          return [:]
        case .mapping(let mapping):
          let pairs: [(String, LeafData)] = mapping.keys.map { (key) in
            (key.string!, mapping[key]!.leafData)
          }
          return Dictionary(uniqueKeysWithValues: pairs)
        case .sequence(let sequence):
          print("got \(sequence), expected mapping")
          return [:]
        }

      } catch {
        print("Error parsing metadata for \(fileLocation.absolutePath)", error)
        return [:]
      }
    }()
    self.init(sha256: string.sha256, metadata: metadata, source: fileLocation)
  }
}

extension Node: LeafDataRepresentable {
  public var leafData: LeafData {
    switch self {
    case .scalar(let scaler):
      return scaler.leafData
    case .mapping(let mapping):
      let pairs = mapping.keys.map { (key) in
        (key.string!, mapping[key]!.leafData)
      }
      return Dictionary(uniqueKeysWithValues: pairs).leafData
    case .sequence(let sequence):
      return sequence.map({ $0.leafData }).leafData
    }
  }
}


extension Node.Scalar: LeafDataRepresentable {
  public var leafData: LeafData {
    self.string.leafData
  }
}
