import Foundation
import MPath
import XCTest
@testable import LeafPressKit


struct IntegrationTestRunner {
  let fixtureName: String
  let expectedRoutes: Set<String>
  let tmpDir = Path("/tmp/TestOutput")
  let expectedDir: Path
  let workDir: Path
  let distDir: Path
  let config: Config
  init(fixtureName: String, expectedRoutes: Set<String>) {
    self.fixtureName = fixtureName
    self.expectedRoutes = expectedRoutes

    self.workDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/src")
    self.expectedDir = Path(Bundle.module.resourcePath!) + Path("Fixtures/\(fixtureName)/expected")
    self.distDir = tmpDir + Path(fixtureName)

    self.config = Config(workDir: workDir,
    distDir: distDir,
    postsPublishPrefix: "posts",
    pagesDir: workDir + "pages",
    postsDir: workDir + "posts",
    staticFilesDir: workDir + "static",
    templatesDir: workDir + "templates",
    publishedDateStyle: .medium,
    publishedTimeStyle: nil,
    postBuildScript: nil)
  }

  func setup() throws {
    try tmpDir.createDirectories()

    print(Bundle.module.resourcePath!)
    if distDir.exists { try distDir.delete() }
    try distDir.createDirectories()
  }

  func build() {
    print("*** Building project to \(distDir.string), view using: docker run -p 8080:80 -v \(distDir.string)/:/usr/share/nginx/html/ nginx")

    let buildActionResult = BuildAction(config: config).build(skipStatic: false,
                                                              skipScript: true,
                                                              includeDrafts: false)

    switch buildActionResult {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
        return
    case .success:
      return
    }
  }

  func internalRepresentatinon() throws -> Website {
    let tuple: (Website, [Error]) = try MultiThreadedContext(numberOfThreads: 1).run { (eventLoopGroup, threadPool) in
      let loader = InternalRepresentationLoader(config: config, includeDrafts: false, includeStatic: true)
      let result = loader.load(threadPool: threadPool, eventLoopGroup: eventLoopGroup)

      return result
    }

    for error in tuple.1 {
      XCTFail(error.localizedDescription)
    }
    return tuple.0
  }

  func assertDirectoryMatchOfFixtureAndTestOutput() throws {
      try assertDirectoriesMatch(expectedDir: expectedDir, actualDir: distDir)
    }

  func assertFilesExistForRoutes() {
    assertRoutesExist(routes: expectedRoutes, distDir: distDir)
  }

  func assertRoutes() {
    switch RoutesAction(config: config).list(includeDrafts: false, includeStatic: true) {
    case .failure(let error):
      XCTFail("Failure building. Error: \(error.localizedDescription)")
        return
    case .success(let success):
      let routes = success.0
      let errors = success.1
      XCTAssertEqual(Set(routes).sorted().joined(separator: "\n"), multiline: expectedRoutes.sorted().joined(separator: "\n"), "routes")
      XCTAssertEqual(errors.map { $0.localizedDescription }, [], "exepcted no errors")
    }
  }

}
