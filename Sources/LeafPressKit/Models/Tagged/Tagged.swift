import Foundation

public struct Tagged<Tag, RawValue>: RawRepresentable {
  public let rawValue: RawValue
  public init(rawValue: RawValue) {
    self.rawValue = rawValue
  }

  public init(_ rawValue: RawValue) {
    self.rawValue = rawValue
  }

  public init?(maybe: RawValue?) {
    if let rawValue = maybe {
      self.init(rawValue)
    } else {
      return nil
    }
  }
}

extension Tagged: Encodable where RawValue: Encodable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}
extension Tagged: Decodable where RawValue: Decodable {
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    self.init(rawValue: try container.decode(RawValue.self))
  }
}

extension Tagged: Hashable where RawValue: Hashable {
  public var hashValue: Int {
    return rawValue.hashValue
  }
}

extension Tagged: Equatable where RawValue: Equatable {
  public static func == (left: Tagged<Tag, RawValue>, right: Tagged<Tag, RawValue>) -> Bool {
    return left.rawValue == right.rawValue
  }
}

extension Tagged: Comparable where RawValue: Comparable {
  public static func < (left: Tagged<Tag, RawValue>, right: Tagged<Tag, RawValue>) -> Bool {
    return left.rawValue < right.rawValue
  }
}

extension Tagged: ExpressibleByIntegerLiteral where RawValue == Int {
  public typealias IntegerLiteralType = Int
  public init(integerLiteral value: Int) {
    self.init(rawValue: value)
  }

  public var int: Int {
    return self.rawValue
  }
}
extension Tagged: ExpressibleByUnicodeScalarLiteral where RawValue == String { }
extension Tagged: ExpressibleByExtendedGraphemeClusterLiteral where RawValue == String { }
extension Tagged: ExpressibleByStringLiteral where RawValue == String {
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  public typealias UnicodeScalarLiteralType = StringLiteralType

  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    self.rawValue = String(value)
  }

  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    self.rawValue = String(value)
  }

  public init(stringLiteral value: StringLiteralType) {
    self.rawValue = String(value)
  }

  public var string: String {
    return self.rawValue
  }
}
