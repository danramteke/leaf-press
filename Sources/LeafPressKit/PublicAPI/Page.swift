import Foundation
import MPath
import LeafKit

public struct Page: Renderable, Comparable, Equatable {
  public static func < (lhs: Page, rhs: Page) -> Bool {
    lhs.title < rhs.title
  }
  public let template: String
  public let slug: String
  public let title: String
  public let summary: String?

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL

  public let metadata: [String: LeafData]
  public let isIncluded: Bool
  public let category: String?
  public let date: Date?
}
extension Page: LeafDataRepresentable {
  public var leafData: LeafData {
    let dict: [String: LeafData] = [
      "slug": self.slug.leafData,
      "title": self.title.leafData,
      "summary": self.summary?.leafData ?? LeafData.nil(.string),
      "relativeURL": self.relativeUrl.relativeString.leafData,
      "metadata": self.metadata.leafData,
      "category": self.category?.leafData ?? LeafData.nil(.string)
    ]
    return dict.leafData
  }
}
