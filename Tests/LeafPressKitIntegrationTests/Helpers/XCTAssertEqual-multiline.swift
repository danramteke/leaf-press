import XCTest
import Foundation

func XCTAssertEqual(
  _ text: String,
  multiline reference: String,
  _ comment: String,
  file: StaticString = #file,
  line: UInt = #line
) {

  // 2.
  let textLines = text.split(separator: "\n", omittingEmptySubsequences: false)
  let referenceLines = reference.split(separator: "\n", omittingEmptySubsequences: false) 
  
  // 3.
  for idx in 0..<max(textLines.count, referenceLines.count) {
    // 5.
    let left = textLines[safely: idx]
    let right = referenceLines[safely: idx] 
    
    // 6.
    let line = line + UInt(1 + idx) 
    
    // 7.
    if let left = left, let right = right {
      XCTAssertEqual(left, right, comment, file: file, line: line)
    } else {
      XCTAssertEqual(left, right, comment, file: file, line: line)
    }
  }
}

// 4.
private extension Array {
  subscript(safely index: Index) -> Element? {
    if self.indices.contains(index) {
      return self[index]
    } else {
      return nil
    }
  }
}