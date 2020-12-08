import XCTest
import LeafPressKit
import PathKit

class IntegrationTests: XCTestCase {
  
  func testMarkdownProject() throws {
    let fixtureName = "MarkdownProject"
    let expectedRoutes: Set<String>  = ["/posts/sample-post.html", "/posts/html-post.html", "/leaf-sample.html", "/frontmatter-template-sample.html", "/index.html", "/posts/sample-post-with-custom-template.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }

  func testLeafProject() throws {
    let fixtureName = "LeafProject"
    let expectedRoutes: Set<String> = ["/extend-template.html", "/frontmatter-variable-no-template.html", "/frontmatter.html", "/index.html", "/partials.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }
}
