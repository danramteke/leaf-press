import Foundation
import Yams
import LeafKit

extension Node {
  public func leafData() throws -> LeafData {
    switch self {
    case .scalar(let scaler):
      return scaler.leafData
    case .mapping(let mapping):
      return try LeafData.dictionary(mapping.asStringsToLeafData())
    case .sequence(let sequence):
      return try sequence.map({ try $0.leafData() }).leafData
    }
  }
}

extension Node.Mapping {
  func asStringsToLeafData() throws -> [String: LeafData] {
    let pairs: [(String, LeafData)] = try self.map { (key, value) in
      guard let keyAsString = key.string else {
        throw NonStringNodeKey()
      }
      return (keyAsString, try value.leafData())
    }

    return Dictionary(uniqueKeysWithValues: pairs)
  }
}


extension Node.Scalar: LeafDataRepresentable {
  public var leafData: LeafData {
    self.string.leafData
  }
}
