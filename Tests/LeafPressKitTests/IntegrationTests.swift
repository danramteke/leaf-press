import XCTest
import LeafPressKit
import PathKit

class IntegrationTests: XCTestCase {
  
  func testMarkdownProject() throws {
    let testMode = TestMode.compare

    let tmpDir = Path("/tmp/leaf-press/Tests")
    try tmpDir.mkpath()

    let workDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/MarkdownProject/src")
    let expectedDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/MarkdownProject/expected")
    let distDir: Path = {
      switch testMode {
      case .compare: return tmpDir + Path("MarkdownProject")
      case .record(let path): return path
      }
    }()

    try? distDir.delete()

    print("Building project to \(distDir.absolute().string)")

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

    switch testMode {
      case .record: return
      case .compare: break
    }
    switch BuildAction(config: config).build(ignoreStatic: false) {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
    case .success:
      try assertDirectoriesMatch(expectedDir: expectedDir, actualDir: distDir)
    }


    switch RoutesAction(config: config).list() {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
    case .success(let routes):
      XCTAssertEqual(routes, ["/frontmatter-template-sample.html", "/pure-leaf-template-sample.html", "/posts/sample-post.html"])
    }
  }
}
