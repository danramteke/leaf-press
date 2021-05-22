import Foundation
import MPath

struct DateFromDirectoryPath: Hashable, Equatable {
  let year: Int
  let month: Int
  let day: Int
  let date: Date

  var dateComponents: [Int] {
    return [year, month, day]
  }

  init?(directoryPath: String) {
    self.init(directoryPath: Path(directoryPath))
  }

  init?(directoryPath: Path) {

    guard directoryPath.components.count > 3 else {
      return nil
    }

    let ints = directoryPath.components[0...2].compactMap({ Int($0) })

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
