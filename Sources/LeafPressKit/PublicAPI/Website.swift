import Foundation
import LeafKit

public class Website {
  public let pages: [Page]
  public let posts: [Post]
  public let staticFiles: [StaticFile]
  public let categories: Dictionary<String, [Page]>
  public let categoriesByDate: Dictionary<String, [Page]>

  public let categoriesNewestFive: Dictionary<String, [Page]>

  public init(pages: [Page], posts: [Post], staticFiles: [StaticFile]) {
    self.posts = posts.sorted()
    self.staticFiles = staticFiles.sorted()

    let sortedPages = pages.sorted()
    self.pages = sortedPages
    self.categories = Dictionary(grouping: sortedPages.filter { $0.category != nil }, by: { $0.category! })
    self.categoriesByDate = Dictionary(grouping: pages.filter { $0.date != nil }.sorted(by: { $1.date! < $0.date! }).filter { $0.category != nil }, by: { $0.category! })
    self.categoriesNewestFive = Dictionary(grouping: pages.filter { $0.date != nil }.sorted(by: { $1.date! < $0.date! }).prefix(5).filter { $0.category != nil }, by: { $0.category! })
  }
}

extension Website: LeafDataRepresentable {
  public var leafData: LeafData {
    [
      "pages": self.pages.leafData,
      "posts": self.posts.leafData,
      "categories": self.categories.mapValues { $0.leafData }.leafData,
      "categoriesByDate": self.categoriesByDate.mapValues { $0.leafData }.leafData,
      "categoriesNewestFive": self.categoriesNewestFive.mapValues { $0.leafData }.leafData
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
