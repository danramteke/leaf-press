import Foundation
import MPath

extension Date {
  var pathFragment: Path {
    let calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
    let dateComponents = calendar.dateComponents(Set<Calendar.Component>(arrayLiteral: .year, .month, .day), from: self)

    return [dateComponents.year, dateComponents.month, dateComponents.day]
      .compactMap { $0 }
      .map { Path(String(format: "%02d", $0)) }
      .reduce(Path(), +)
  }
}
