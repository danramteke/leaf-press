import Foundation
@testable import LeafPressKit
import XCTest
import LeafKit

class InputFileLoaderTests: XCTestCase {
  func testEmptyFrontMatter() throws {
    let input = """
    # Hello world

    How are you?
    """
    let expectedContent = """
    # Hello world

    How are you?
    """
    XCTAssertEqual(InputFileParser().content(from: input), expectedContent)
    XCTAssertEqual(try InputFileParser().metadata(from: input), [:])
  }


  func testBasics() throws {
    let input = """
      ---
      title: Hello
      category: greetings
      summary: A popular greeting
      ---
      # Hello world

      How are you?
      """
    let expectedContent = """
      # Hello world

      How are you?
      """
    XCTAssertEqual(InputFileParser().content(from: input), expectedContent)

    let expectedMetaData: [String: LeafData] = [
      "title": "Hello".leafData,
      "category": "greetings".leafData,
      "summary": "A popular greeting".leafData,
    ]
    XCTAssertEqual(try InputFileParser().metadata(from: input), expectedMetaData)

  }
}
