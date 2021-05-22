import XCTest
import Foundation
import MPath

func assertRoutesExist(routes: Set<String>, distDir: Path, file: StaticString = #file, line: UInt = #line) {
  for route in routes {
    var path: Path
    if route.hasPrefix("/") {
      path = distDir + Path(String(route.dropFirst()))
    } else {
      path = distDir + Path(route)
    }
    XCTAssertTrue(path.exists, "Expected \(route) to exist at \(path.string)", file: file, line: line)
  }
}
