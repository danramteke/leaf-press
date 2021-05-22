import XCTest
import LeafPressKit
import MPath

class MarkdownProjectIntegrationTests: XCTestCase {
  let fixtureName = "MarkdownProject"
  let expectedRoutes: Set<String>  = [
    "/leaf-sample.html",
    "/posts/2020/06/01/sample-post-with-custom-template.html",
    "/posts/2020/08/01/html-post-with-custom-template.html",
    "/frontmatter-template-sample.html",
    "/index.html",
    "/posts/2020/12/01/html-post.html",
    "/posts/2020/11/01/sample-post.html",
    "/posts/2020/08/28/date-prefix.html",
    "/posts/2020/12/06/date-from-path.html",
    "/styles.css",
    "/posts/2020/12/06/images/image.png",
    "/subfolder/text.txt",
    "/subfolder2/download.html",
  ]

  lazy var runner = IntegrationTestRunner(fixtureName: fixtureName,
                                          expectedRoutes: expectedRoutes)

  override func setUpWithError() throws {
    try runner.setup()
  }

  func testRoutes() {
    runner.build()
    runner.assertRoutes()
  }

  func testFilesExistForRoutes() {
    runner.build()
    runner.assertFilesExistForRoutes()
  }

  func testDirectoryMatchOfFixtureAndTestOutput() throws {
    runner.build()
    try runner.assertDirectoryMatchOfFixtureAndTestOutput()
  }

  func testInternalRepresentation() throws {
    let website = try runner.internalRepresentatinon()

    print(website.posts)
  }
}
