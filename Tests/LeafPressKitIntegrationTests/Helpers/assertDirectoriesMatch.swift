import Foundation
import PathKit
import XCTest

func assertDirectoriesMatch(expectedDir: Path, actualDir: Path, file: StaticString = #file, line: UInt = #line) throws {
  try expectedDir.recursiveChildren().forEach { expectedPath in
    if expectedPath.isDirectory { return }
    let relativePath = expectedPath.relative(to: expectedDir)

    let expectedContents: Data = try expectedPath.read()
    let actualPath = actualDir + relativePath

    guard actualPath.exists else {
      XCTFail("expected \(relativePath.string) to exist at \(actualPath.string)", file: file, line: line)
      return
    }

    do {
      let actualContents: Data = try actualPath.read()

      if let actualContentsString = String(data: actualContents, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
         let expectedContentsString = String(data: expectedContents, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
        XCTAssertEqual(actualContentsString, expectedContentsString, "Actual contents at \(actualPath.string) does not match expected contents at \(expectedPath.string)", file: file, line: line)
      } else {
        XCTAssertEqual(actualContents, expectedContents, "Actual data at \(actualPath.string) does not match expected data at \(expectedPath.string)", file: file, line: line)
      }
    } catch {
      XCTFail("expected \(relativePath.string) to be readable at \(actualPath.string)", file: file, line: line)
    }
  }
}
