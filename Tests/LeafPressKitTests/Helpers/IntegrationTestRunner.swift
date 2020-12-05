import Foundation
import PathKit
import XCTest
import LeafPressKit

struct IntegrationTestRunner {
  func run(fixtureName: String, expectedRoutes: [String]) throws {
    let tmpDir = Path("/tmp/leaf-press/Tests")
    try tmpDir.mkpath()

    let workDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/src")
    let expectedDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/expected")
    let distDir: Path = tmpDir + Path(fixtureName)

    try? distDir.delete()
    try distDir.mkpath()

    print("Building project to \(distDir.string)")

    let config = Config(workDir: workDir,
                        distDir: distDir,
                        postsPublishPrefix: "posts",
                        pagesDir: workDir + "pages",
                        postsDir: workDir + "posts",
                        staticFilesDir: workDir + "static",
                        templatesDir: workDir + "templates",
                        publishedDateStyle: .medium,
                        publishedTimeStyle: nil,
                        postBuildScript: nil)

    let buildActionResult = BuildAction(config: config).build(ignoreStatic: false)

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
