import LeafKit
import Foundation

extension Post: LeafDataRepresentable {
  public var leafData: LeafData {
    let dict = [
      "slug": self.slug.leafData,
      "title": self.title?.leafData ?? LeafData.nil(.string),
      "summary": self.summary?.leafData ?? LeafData.nil(.string),
      "relativeUrl": self.relativeUrl.relativeString.leafData,

      "published": self.published?.date?.leafData ?? self.published?.rawValue.leafData ?? LeafData.nil(.string)
    ]
    return LeafData.dictionary(dict)
  }
}
