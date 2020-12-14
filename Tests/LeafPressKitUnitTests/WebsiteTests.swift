import Foundation
import XCTest
@testable import LeafPressKit

class WebsiteTests: XCTestCase {
  func testBasics() {
    let page1 = buildTestPage(slug: "page1", category: nil)
    let page2 = buildTestPage(slug: "page2", category: "greetings")
    let page3 = buildTestPage(slug: "page2", category: "greetings")

    let website = Website(pages: [page1, page2, page3], posts: [])

    XCTAssertEqual(website.pages.count, 3)
    XCTAssertEqual(website.posts.count, 0)
    XCTAssertEqual(website.categories.count, 1)
    XCTAssertEqual(website.categories["greetings"]?.count, 2)
  }

  private func buildTestPage(slug: String, category: String?) -> Page {
    Page(template: "", slug: slug, title: slug, summary: nil, source: FileLocation(root: "", directoryPath: "", slug: slug, fileExtension: nil), target: FileLocation(root: "", directoryPath: "", slug: slug, fileExtension: nil), relativeUrl: URL(string: slug)!, metadata: [:], isIncluded: true, category: category)
  }
}
