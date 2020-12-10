import XCTest
@testable import LeafPressKit

class StringTests: XCTestCase {
  func testDatePrefix() {
    XCTAssertEqual("2020-10-07-sample-file".datePrefix, "2020-10-07")
    XCTAssertEqual("2020-10-07_sample-file".datePrefix, "2020-10-07")
    XCTAssertEqual("2020-10-0_sample-file".datePrefix, nil)
    XCTAssertEqual("2020-10-10".datePrefix, nil)
    XCTAssertEqual("sample-2020-10-12-sample".datePrefix, nil)
    XCTAssertEqual("sample-2020-10-11".datePrefix, nil)
    XCTAssertEqual("2020-10-19sample".datePrefix, nil)
  }
}
