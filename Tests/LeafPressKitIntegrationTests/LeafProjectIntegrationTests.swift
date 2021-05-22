import XCTest
import LeafPressKit
import MPath

class LeafProjectIntegrationTests: XCTestCase {
  let fixtureName = "LeafProject"
  let expectedRoutes: Set<String> = [
    "/extend-template.html",
    "/frontmatter-variable-no-template.html",
    "/frontmatter.html",
    "/index.html",
    "/partials.html",
  ]

  lazy var runner = IntegrationTestRunner(fixtureName: fixtureName,
                                          expectedRoutes: expectedRoutes)

  override func setUpWithError() throws {
    try runner.setup()
    runner.build()
  }

  func testRoutes() {
    runner.assertRoutes()
  }

  func testFilesExistForRoutes() {
    runner.assertFilesExistForRoutes()
  }

  func testDirectoryMatchOfFixtureAndTestOutput() throws {
    try runner.assertDirectoryMatchOfFixtureAndTestOutput()
  }
}
