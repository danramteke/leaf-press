import Foundation

public struct Website {
  public let pages: [Page]
  public let posts: [Post]

  public init(pages: [Page], posts: [Post]) {
    self.pages = pages
    self.posts = posts
  }
}
