import Foundation
import PathKit
import LeafKit

public struct Page: Renderable {
  public let template: String
//  public typealias Id = Tagged<Page, String>
  public let slug: String
  public let title: String?
  public let summary: String?

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL

  public let metadata: [String: LeafData]

  let sha256: String
}
