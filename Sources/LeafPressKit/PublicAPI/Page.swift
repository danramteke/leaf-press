import Foundation
import PathKit

public struct Page: Codable {
  public typealias Id = Tagged<Page, String>
  public let slug: Id
  public let title: String
  public let summary: String

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL
}
