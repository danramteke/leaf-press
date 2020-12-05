import Foundation
import PathKit
import XCTest

func assertDirectoriesMatch(expectedDir: Path, actualDir: Path, file: StaticString = #file, line: UInt = #line) throws {
  try expectedDir.glob("{*,**/*}.*").forEach { expectedPath in
    print("matching ", expectedPath.string)
    let relativePath = expectedPath.relative(to: expectedDir)

    let expectedContents: Data = try expectedPath.read()
    let actualPath = actualDir + relativePath
    XCTAssertTrue(actualPath.exists, "expected \(relativePath.string) to exist at \(actualPath.string)", file: file, line: line)

    do {
      let actualContents: Data = try actualPath.read()

      if let actualContentsString = String(data: actualContents, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
         let expectedContentsString = String(data: expectedContents, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
        XCTAssertEqual(actualContentsString, expectedContentsString, file: file, line: line)
      } else {
        XCTAssertEqual(actualContents, expectedContents, file: file, line: line)
      }
    } catch {
      XCTFail("expected \(relativePath.string) to be readable at \(actualPath.string)", file: file, line: line)
    }
  }
}
