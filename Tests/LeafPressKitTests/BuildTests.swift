import XCTest
import LeafPressKit
import PathKit

class BuildTests: XCTestCase {
  func testAsdf() throws {
    let tmpDir = Path("/tmp/leaf-press/Tests")
    try tmpDir.mkpath()

    let workDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/MarkdownProject/src")
    let expectedDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/MarkdownProject/expected")
    let distDir = tmpDir + Path("MarkdownProject")

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


    let result = BuildAction(config: config).build(ignoreStatic: false)
    switch result {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
    case .success:
      break
    }


//    expectedDir.glob("*").
  }
}
