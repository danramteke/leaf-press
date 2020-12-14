import Foundation
import PathKit
import XCTest
import LeafPressKit

struct IntegrationTestRunner {
  func run(fixtureName: String, expectedRoutes: Set<String>) throws {
    let tmpDir = Path("/tmp/TestOutput")
    try tmpDir.mkpath()

    print(Bundle.module.resourcePath!)

    let workDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/src")
    let expectedDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/expected")
    let distDir: Path = tmpDir + Path(fixtureName)

    if distDir.exists { try distDir.delete() }
    try distDir.mkpath()

    print("*** Building project to \(distDir.string), view using: docker run -p 8080:80 -v \(distDir.string)/:/usr/share/nginx/html/ nginx")

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

    let buildActionResult = BuildAction(config: config).build(skipStatic: false, skipScript: true, includeDrafts: false)

    switch buildActionResult {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
    case .success:
      try assertDirectoriesMatch(expectedDir: expectedDir, actualDir: distDir)
    }


    switch RoutesAction(config: config).list(includeDrafts: false) {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
    case .success(let success):
      let routes = success.0
      let errors = success.1
      XCTAssertEqual(Set(routes), expectedRoutes)
      XCTAssertEqual(errors.count, 0)
    }

    assertRoutesExist(routes: expectedRoutes, distDir: distDir)
  }

}
