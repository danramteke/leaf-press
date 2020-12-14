
import Foundation

extension String {
  public func removing(suffix: String) -> String? {
    guard self.hasSuffix(suffix) else { return nil }
    if let range = self.range(of: suffix) {
      let slice = self[..<range.lowerBound]
      return String(slice)
    } else {
      return nil
    }
  }

  var datePrefix: String? {
    guard let range = self.range(of: #"^\d\d\d\d-\d\d-\d\d[-_]"#, options: .regularExpression) else {
      return nil
    }

    return self[range.lowerBound..<self.index(before: range.upperBound)].string
  }
}

extension Substring {
  var string: String {
    String(self)
  }
}
