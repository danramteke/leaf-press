import Foundation
import PathKit
import LeafKit

public struct Page: Renderable {
  public let template: String
  public let slug: String
  public let title: String?
  public let summary: String?

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL

  public let metadata: [String: LeafData]

  let sha256: String
}
extension Page: LeafDataRepresentable {

  

  public var leafData: LeafData {
    let dict: [String: LeafData] = [
      "slug": self.slug.leafData,
      "title": self.title?.leafData ?? LeafData.nil(.string),
      "summary": self.summary?.leafData ?? LeafData.nil(.string),
      "relativeURL": self.relativeUrl.relativeString.leafData,
      "metadata": self.metadata.leafData,
    ]
    return dict.leafData
  }
}
