import LeafKit
import Foundation

extension Post: LeafDataRepresentable {
  public var leafData: LeafData {
    let dict = [
      "slug": self.slug.leafData,
      "title": self.title?.leafData ?? LeafData.nil(.string),
      "summary": self.summary?.leafData ?? LeafData.nil(.string),
      "relativeURL": self.relativeUrl.relativeString.leafData,

      "published": self.published.rawValue.leafData,
      "publishedDate": self.publishedDate.leafData,

      "metadata": self.metadata.leafData
    ]
    return LeafData.dictionary(dict)
  }
}
