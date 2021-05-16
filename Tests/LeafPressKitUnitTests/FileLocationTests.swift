import Foundation
@testable import LeafPressKit
import XCTest
import PathKit

class FileLocationTests: XCTestCase {
  func testPageInFolder() {
    let fileLocation = FileLocation(path: "folder/page.md", root: "/private/tmp/pages")
    XCTAssertNil(fileLocation.datePrefix)
    XCTAssertEqual(fileLocation.directoryPath, "folder/")
    XCTAssertEqual(fileLocation.fileExtension, "md")
    XCTAssertEqual(fileLocation.absolutePath, "/private/tmp/pages/folder/page.md")
    XCTAssertEqual(fileLocation.rawFilename, "page.md")
    XCTAssertEqual(fileLocation.relativePath, "folder/page.md")
    XCTAssertEqual(fileLocation.relativeURL, URL(string:"/folder/page.md")!)
    XCTAssertEqual(fileLocation.supportedFileType, .md)
  }

  func testPage() {
    let fileLocation = FileLocation(path: "page.md", root: "/private/tmp/pages")
    XCTAssertNil(fileLocation.datePrefix)
    XCTAssertEqual(fileLocation.directoryPath, "")
    XCTAssertEqual(fileLocation.fileExtension, "md")
    XCTAssertEqual(fileLocation.absolutePath, "/private/tmp/pages/page.md")
    XCTAssertEqual(fileLocation.rawFilename, "page.md")
    XCTAssertEqual(fileLocation.relativePath, "page.md")
    XCTAssertEqual(fileLocation.relativeURL, URL(string:"/page.md")!)
    XCTAssertEqual(fileLocation.supportedFileType, .md)
  }

  func testMultipleDotsPage() {
    let fileLocation = FileLocation(path: "page.2.md", root: "/private/tmp/pages")
    XCTAssertNil(fileLocation.datePrefix)
    XCTAssertEqual(fileLocation.directoryPath, "")
    XCTAssertEqual(fileLocation.fileExtension, "md")
    XCTAssertEqual(fileLocation.absolutePath, "/private/tmp/pages/page.2.md")
    XCTAssertEqual(fileLocation.rawFilename, "page.2.md")
    XCTAssertEqual(fileLocation.relativePath, "page.2.md")
    XCTAssertEqual(fileLocation.relativeURL, URL(string:"/page.2.md")!)
    XCTAssertEqual(fileLocation.supportedFileType, .md)
  }

  func testUnsupported() {
    let fileLocation = FileLocation(path: "unsupported.asdf", root: "/private/tmp/pages")
    XCTAssertNil(fileLocation.datePrefix)
    XCTAssertEqual(fileLocation.directoryPath, "")
    XCTAssertEqual(fileLocation.fileExtension, "asdf")
    XCTAssertEqual(fileLocation.absolutePath, "/private/tmp/pages/unsupported.asdf")
    XCTAssertEqual(fileLocation.rawFilename, "unsupported.asdf")
    XCTAssertEqual(fileLocation.relativePath, "unsupported.asdf")
    XCTAssertEqual(fileLocation.relativeURL, URL(string:"/unsupported.asdf")!)
    XCTAssertNil(fileLocation.supportedFileType)
  }

  func testNoExtension() {
    let fileLocation = FileLocation(path: "no-extension", root: "/private/tmp/pages")
    XCTAssertNil(fileLocation.datePrefix)
    XCTAssertEqual(fileLocation.directoryPath, "")
    XCTAssertEqual(fileLocation.fileExtension, nil)
    XCTAssertEqual(fileLocation.absolutePath, "/private/tmp/pages/no-extension")
    XCTAssertEqual(fileLocation.rawFilename, "no-extension")
    XCTAssertEqual(fileLocation.relativePath, "no-extension")
    XCTAssertEqual(fileLocation.relativeURL, URL(string:"/no-extension")!)
    XCTAssertNil(fileLocation.supportedFileType)
  }
}

