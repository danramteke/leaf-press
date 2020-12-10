import Foundation
import PathKit
import LeafKit

public struct Post: Renderable, Comparable, Equatable {
  public static func < (lhs: Post, rhs: Post) -> Bool {
    lhs.date < rhs.date
  }

  public let template: String
  public let slug: String
  public let title: String?
  public let summary: String?
  
  public let dateString: DateString

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL

  public let date: Date

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

      "dateString": self.dateString.rawValue.leafData,
      "date": self.date.leafData,

      "metadata": self.metadata.leafData,

    ]
    return dict.leafData
  }
}
