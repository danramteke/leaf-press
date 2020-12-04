import LeafKit
import Foundation

extension Post: LeafDataRepresentable {
  public var leafData: LeafData {
    let dict = [
      "slug": self.slug.rawValue.leafData,
      "title": self.title.leafData,
      "summary": self.summary.leafData,
      "relativeUrl": self.relativeUrl.relativeString.leafData,

      "published": self.published.date?.leafData ?? self.published.rawValue.leafData
    ]
    return LeafData.dictionary(dict)
  }
}
