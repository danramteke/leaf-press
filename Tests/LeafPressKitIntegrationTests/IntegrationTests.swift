import XCTest
import LeafPressKit
import PathKit

class IntegrationTests: XCTestCase {
  
  func testMarkdownProject() throws {
    let fixtureName = "MarkdownProject"
    let expectedRoutes: Set<String>  = ["/leaf-sample.html", "/posts/2020/06/01/sample-post-with-custom-template.html", "/posts/2020/08/01/html-post-with-custom-template.html", "/frontmatter-template-sample.html", "/index.html", "/posts/2020/12/01/html-post.html", "/posts/2020/11/01/sample-post.html", "/posts/2020/08/28/date-prefix.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }

  func testLeafProject() throws {
    let fixtureName = "LeafProject"
    let expectedRoutes: Set<String> = ["/extend-template.html", "/frontmatter-variable-no-template.html", "/frontmatter.html", "/index.html", "/partials.html"]

    try IntegrationTestRunner().run(fixtureName: fixtureName, expectedRoutes: expectedRoutes)
  }
}
