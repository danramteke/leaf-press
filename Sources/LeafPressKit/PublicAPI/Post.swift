import Foundation
import PathKit

public struct Post {
  public typealias Id = Tagged<Post, String>
  public let slug: Id
  public let title: String
  public let summary: String
  
  public let published: DateString
}
