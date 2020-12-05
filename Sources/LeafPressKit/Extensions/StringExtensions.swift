
import Foundation
import CommonCrypto

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
    func digest(input: NSData) -> NSData {
      let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
      var hash = [UInt8](repeating: 0, count: digestLength)
      CC_SHA256(input.bytes, UInt32(input.length), &hash)
      return NSData(bytes: hash, length: digestLength)
    }

    func hexStringFromData(input: NSData) -> String {
      var bytes = [UInt8](repeating: 0, count: input.length)
      input.getBytes(&bytes, length: input.length)

      var hexString = ""
      for byte in bytes {
        hexString += String(format:"%02x", UInt8(byte))
      }

      return hexString
    }

    if let stringData = self.data(using: String.Encoding.utf8) {
      return hexStringFromData(input: digest(input: stringData as NSData))
    }
    return ""
  }
}
