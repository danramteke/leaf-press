import Foundation
@testable import LeafPressKit
import XCTest

class InputFileTests: XCTestCase {
  func testEmptyFrontMatter() throws {
    let string = """
    # Hello world

    How are you?
    """
    let inputFile = try self.markdownInputFile(string: string)
    XCTAssertEqual(inputFile.title, "Untitled")
    XCTAssertEqual(inputFile.category, nil)
  }

  func testBasics() throws {
    let string = """
    ---
    title: Hello
    category: greetings
    summary: A popular greeting
    ---
    # Hello world

    How are you?
    """
    let inputFile = try self.markdownInputFile(string: string)
    XCTAssertEqual(inputFile.title, "Hello")
    XCTAssertEqual(inputFile.category, "greetings")
    XCTAssertEqual(inputFile.summary, "A popular greeting")
  }

  private func markdownInputFile(string: String) throws -> InputFileMetadata {
    return try InputFileMetadata(string: string, at: FileLocation(root: "", directoryPath: "", slug: "testFilename", fileExtension: "md"))
  }
}
