import LeafKit
import Foundation

extension Page: LeafDataRepresentable {
  public var leafData: LeafData {
    let dict = [
      "slug": self.slug.rawValue.leafData,
      "title": self.title.leafData,
      "summary": self.summary.leafData,
      "relativeUrl": self.relativeUrl.relativeString.leafData,
    ]
    return LeafData.dictionary(dict)
  }
}
