
import Foundation
import Crypto

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
}

extension Substring {
  var string: String {
    String(self)
  }
}

extension String {
  var sha256: String {
    let digest = SHA256.hash(data: self.data(using: .utf8)!)

    return digest.map { String(format: "%02x", $0) }.joined()
  }

  var datePrefix: String? {
    guard let range = self.range(of: #"^\d\d\d\d-\d\d-\d\d[-_]"#, options: .regularExpression) else {
      return nil
    }

    return self[range.lowerBound..<self.index(before: range.upperBound)].string
  }
}
