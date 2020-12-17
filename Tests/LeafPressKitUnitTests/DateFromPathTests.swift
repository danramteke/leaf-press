import Foundation
import XCTest
import PathKit
@testable import LeafPressKit

class DateFromPathTests: XCTestCase {
  func testBasics() {
    XCTAssertEqual(DateFromDirectoryPath(directoryPath: "2020/12/01/images/")?.dateComponents, [2020,12,1])

    assertDateFromPath("2020/12/01/images/", 2020, 12,1)
    assertDateFromPath("2020/12/images/", nil)
    assertDateFromPath("2020/12/7/8/9/10/images/", 2020, 12,7)
  }

  private func assertDateFromPath(_ st: String, _ year: Int, _ month: Int , _ day: Int, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(DateFromDirectoryPath(directoryPath: st)?.year, year, file: file, line: line)
    XCTAssertEqual(DateFromDirectoryPath(directoryPath: st)?.month, month, file: file, line: line)
    XCTAssertEqual(DateFromDirectoryPath(directoryPath: st)?.day, day, file: file, line: line)
  }

  private func assertDateFromPath(_ st: String, _ other: DateFromDirectoryPath?, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(DateFromDirectoryPath(directoryPath: st), other)
  }
}
