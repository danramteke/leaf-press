import Foundation
import LeafKit

public struct Website {
  public let pages: [Page]
  public let posts: [Post]

  public init(pages: [Page], posts: [Post]) {
    self.pages = pages
    self.posts = posts.sorted()
  }
}

extension Website: LeafDataRepresentable {
  public var leafData: LeafData {
    LeafData.dictionary([
      "pages": self.pages.leafData,
      "posts": self.posts.leafData,
    ])
  }
}
