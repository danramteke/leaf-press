import XCTest
import LeafPressKit
import PathKit

class IntegrationTests: XCTestCase {
  
  func testMarkdownProject() throws {

    let fixtureName = "MarkdownProject"
    let testMode = TestMode.compare
    let expectedRoutes: [String] = ["/frontmatter-template-sample.html", "/pure-leaf-template-sample.html", "/posts/sample-post.html"]

    let tmpDir = Path("/tmp/leaf-press/Tests")
    try tmpDir.mkpath()

    let workDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/src")
    let expectedDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/expected")
    let distDir: Path = {
      switch testMode {
      case .compare: return tmpDir + Path(fixtureName)
      case .record(let path): return path
      }
    }()

    try? distDir.delete()
    try distDir.mkpath()

    print("Building project to \(distDir.string)")

    let config = Config(workDir: workDir,
                        distDir: distDir,
                        postsPublishPrefix: "posts",
                        pagesDir: workDir + "pages",
                        postsDir: workDir + "posts",
                        staticFilesDir: workDir + "static-files",
                        templatesDir: workDir + "templates",
                        publishedDateStyle: .medium,
                        publishedTimeStyle: nil,
                        postBuildScript: nil)

    let buildActionResult = BuildAction(config: config).build(ignoreStatic: false)

    switch testMode {
      case .record: return
      case .compare: break
    }
    switch buildActionResult {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
    case .success:
      try assertDirectoriesMatch(expectedDir: expectedDir, actualDir: distDir)
    }


    switch RoutesAction(config: config).list() {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
    case .success(let routes):
      XCTAssertEqual(routes, expectedRoutes)
    }
  }
}
