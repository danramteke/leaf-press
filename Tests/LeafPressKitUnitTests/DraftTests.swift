import Foundation
import XCTest
@testable import LeafPressKit


class DraftTests: XCTestCase {
  func testNotDraft() throws {
    let string = """
    ---
    title: Hello
    draft: false
    ---
    # Hello world

    How are you?
    """
    XCTAssertTrue(try self.markdownInputFile(string: string).isIncluded)
  }

  func testDraft() throws {
    let string = """
    ---
    title: Hello
    draft: true
    ---
    # Hello world

    How are you?
    """
    XCTAssertFalse(try self.markdownInputFile(string: string).isIncluded)
  }

  func testUnparsebleDraftIsStillConsideredDraft() throws {
    let string = """
    ---
    title: Hello
    draft: unparsable
    ---
    # Hello world

    How are you?
    """
    XCTAssertFalse(try self.markdownInputFile(string: string).isIncluded)
  }

  func testMissingDraftIsNotConsideredDraft() throws {
    let string = """
    ---
    title: Hello
    ---
    # Hello world

    How are you?
    """
    XCTAssertTrue(try self.markdownInputFile(string: string).isIncluded)
  }

  private func markdownInputFile(string: String) throws -> InputFile {
    return try InputFile(string: string, at: FileLocation(root: "", directoryPath: "", slug: "rawFilename", fileExtension: "md"))
  }
}
