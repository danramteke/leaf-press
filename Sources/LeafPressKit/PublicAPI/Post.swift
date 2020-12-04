import Foundation
import PathKit

public struct Post: Codable, Renderable {
  public let template: String

//  public typealias Id = Tagged<Post, String>
  public let slug: String
  public let title: String?
  public let summary: String?
  
  public let published: DateString?

  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL
}
