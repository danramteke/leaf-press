import Foundation
import PathKit

public struct Post: Codable, Renderable, Comparable, Equatable {
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

  public let frontMatter: [String: String]

  let sha256: String
}
