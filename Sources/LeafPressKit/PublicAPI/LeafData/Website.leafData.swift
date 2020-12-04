import LeafKit
import Foundation

extension Website:LeafDataRepresentable {
  public var leafData: LeafData {
    LeafData.dictionary([
      "pages": self.pages.leafData,
      "posts": self.posts.leafData,
    ])
  }
}
