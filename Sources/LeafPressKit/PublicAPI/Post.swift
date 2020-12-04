import Foundation
import PathKit

public struct Post {
  public typealias Id = Tagged<Post, String>
  public let slug: Id
  public let title: String
  public let summary: String
  
  public let published: DateString

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL
}