import XCTest

import LeafPressKitIntegrationTests
import LeafPressKitUnitTests

var tests = [XCTestCaseEntry]()
tests += LeafPressKitIntegrationTests.__allTests()
tests += LeafPressKitUnitTests.__allTests()

XCTMain(tests)
