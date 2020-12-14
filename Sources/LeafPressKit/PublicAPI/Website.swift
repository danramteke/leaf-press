import Foundation
import LeafKit

public class Website {
  public let pages: [Page]
  public let posts: [Post]
  public let categories: Dictionary<String, [Page]>

  public init(pages: [Page], posts: [Post]) {
    self.pages = pages
    self.posts = posts.sorted()
    self.categories = Dictionary(grouping: pages.filter { $0.category != nil }, by: { $0.category! })
  }
}

extension Website: LeafDataRepresentable {
  public var leafData: LeafData {
    [
      "pages": self.pages.leafData,
      "posts": self.posts.leafData,
      "categories": self.categories.mapValues { $0.leafData }.leafData
    ].leafData
  }
}

//
//public struct Group {
//  public let pages: Array<Page>
//}

//self.groups.map({
//  let (key: String, value: [Page]) = $0
//  return (key, value.leafData)
//})
