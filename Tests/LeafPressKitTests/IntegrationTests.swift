import XCTest
import LeafPressKit
import PathKit

class IntegrationTests: XCTestCase {
  
  func testMarkdownProject() throws {
    let fixtureName = "MarkdownProject"
    let expectedRoutes: [String] = ["/frontmatter-template-sample.html", "/index.html", "/leaf-sample.html", "/posts/sample-post-with-custom-template.html", "/posts/html-post-with-custom-template.html", "/posts/sample-post.html", "/posts/html-post.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }

  func testLeafProject() throws {
    let fixtureName = "LeafProject"
    let expectedRoutes: [String] = ["/index.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }
}
