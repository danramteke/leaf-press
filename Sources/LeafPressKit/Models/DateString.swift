import Foundation

public struct DateString: RawRepresentable, Codable, Equatable {
  public let rawValue: String

  public func date(for config: Config) -> Date? {
    config.date(from: self.rawValue)
  }

  public init(rawValue: String) {
    self.rawValue = rawValue
  }
}

extension String {
  var dateString: DateString {
    DateString(rawValue: self)
  }
}
