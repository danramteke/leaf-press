import Foundation
import MPath

struct DatePrefix: Hashable, Equatable {
  let string: String
  let year: Int
  let month: Int
  let day: Int
  let date: Date
  let originalRange: Range<String.Index>

  var pathFragment: Path {
    [year, month, day]
      .map { Path(String(format: "%02d", $0)) }
      .reduce(Path(), +)
  }

  init?(filename: String) {
    guard let range = filename.range(of: #"^\d\d\d\d-\d\d-\d\d[-_]"#, options: .regularExpression) else {
      return nil
    }

    self.originalRange = range

    let string = filename[range.lowerBound..<filename.index(before: range.upperBound)].string
    self.string = string

    let ints = string
      .components(separatedBy: "-")
      .compactMap({ Int($0) })

    guard ints.count == 3 else {
      return nil
    }

    self.year = ints[0]
    self.month = ints[1]
    self.day = ints[2]

    let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    let components = DateComponents(calendar: calendar, year: year, month: month, day: day)
    guard let date = components.date else {
      return nil
    }
    self.date = date
  }
}
