import Foundation
import PathKit

public struct Page: Codable, Renderable {
//  public typealias Id = Tagged<Page, String>
  public let slug: String
  public let title: String?
  public let summary: String?

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL
}
