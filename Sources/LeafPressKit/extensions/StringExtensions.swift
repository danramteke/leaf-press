
import Foundation

extension String {
  public func removing(suffix: String) -> String? {
    guard self.hasSuffix(suffix) else {
      return self
    }

    guard let range = self.range(of: suffix) else {
      return self
    }

    return self[..<range.lowerBound].string
  }

  public func removing(prefix: String) -> String {
    guard self.hasPrefix(prefix) else {
      return self
    }
    guard let range = self.range(of: prefix) else {
      return self
    }

    return self[range.upperBound...].string
  }
}

extension Substring {
  var string: String {
    String(self)
  }
}
