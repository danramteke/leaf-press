
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
    let string = digest.map { byte in
      String(format: "%02x", byte)
    }.joined()
    return string
  }
}
