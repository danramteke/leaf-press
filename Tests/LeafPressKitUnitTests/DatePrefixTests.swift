import XCTest
@testable import LeafPressKit

class DatePrefixTests: XCTestCase {
  func testDatePrefix() {
    XCTAssertEqual(DatePrefix(filename: "2020-10-07-sample-file")?.string, "2020-10-07")
    XCTAssertEqual(DatePrefix(filename: "2020-10-07_sample-file")?.string, "2020-10-07")
    XCTAssertEqual(DatePrefix(filename: "2020-10-0_sample-file"), nil)
    XCTAssertEqual(DatePrefix(filename: "2020-10-10"), nil)
    XCTAssertEqual(DatePrefix(filename: "sample-2020-10-12-sample"), nil)
    XCTAssertEqual(DatePrefix(filename: "sample-2020-10-11"), nil)
    XCTAssertEqual(DatePrefix(filename: "2020-10-19sample"), nil)
    XCTAssertEqual(DatePrefix(filename: "2020-75-75-sample")?.string, "2020-75-75")
  }
}
