import Foundation
import PathKit
import LeafKit

public struct Post: Renderable, Comparable, Equatable {
  public static func < (lhs: Post, rhs: Post) -> Bool {
    lhs.publishedDate < rhs.publishedDate
  }

  public let template: String
  public let slug: String
  public let title: String?
  public let summary: String?
  
  public let published: DateString

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL

  public let publishedDate: Date

  public let metadata: [String: LeafData]

  let sha256: String
}

extension Post: LeafDataRepresentable {
  public var leafData: LeafData {
    let dict: [String: LeafData] = [
      "slug": self.slug.leafData,
      "title": self.title?.leafData ?? LeafData.nil(.string),
      "summary": self.summary?.leafData ?? LeafData.nil(.string),
      "relativeURL": self.relativeUrl.relativeString.leafData,

      "published": self.published.rawValue.leafData,
      "publishedDate": self.publishedDate.leafData,

      "metadata": self.metadata.leafData,

    ]
    return dict.leafData
  }
}
