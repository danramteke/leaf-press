import Foundation
import PathKit

public struct Page {
  public typealias Id = Tagged<Page, String>
  public let slug: Id
  public let title: String
  public let summary: String
}
