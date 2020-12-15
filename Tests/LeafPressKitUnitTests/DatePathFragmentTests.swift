import Foundation
import XCTest
import PathKit
@testable import LeafPressKit

class DatePathFragmentTests: XCTestCase {
  func testBasic() {

    assertPathFragment(1608017097, "2020/12/15")
    assertPathFragment(1602000097, "2020/10/06")
    assertPathFragment(1600000097, "2020/09/13")
  }

  private func assertPathFragment(_ t: TimeInterval, _ p: Path, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(Date(timeIntervalSince1970: t).pathFragment, p, file: file, line: line)
  }
}
