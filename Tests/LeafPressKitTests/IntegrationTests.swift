import XCTest
import LeafPressKit
import PathKit

class IntegrationTests: XCTestCase {
  
  func testMarkdownProject() throws {
    let fixtureName = "MarkdownProject"
    let expectedRoutes: Set<String>  = ["/leaf-sample.html", "/posts/sample-post-with-custom-template.html", "/posts/html-post-with-custom-template.html", "/frontmatter-template-sample.html", "/index.html", "/posts/html-post.html", "/posts/sample-post.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }

  func testLeafProject() throws {
    let fixtureName = "LeafProject"
    let expectedRoutes: Set<String> = ["/extend-template.html", "/frontmatter-variable-no-template.html", "/frontmatter.html", "/index.html", "/partials.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }
}
