import Foundation

public struct DateString: RawRepresentable, Codable {
  public let rawValue: String

  public var date: Date? {
    return nil
  }

  public init(rawValue: String) {
    self.rawValue = rawValue
  }

//  var dateComponents: DateComponents {
//    var c = DateComponents(
//      calendar: Calendar.current,
//      timeZone: TimeZone.current,
//
//      year: <#T##Int?#>, month: <#T##Int?#>, day: <#T##Int?#>, hour: <#T##Int?#>, minute: <#T##Int?#>, second: <#T##Int?#>, nanosecond: <#T##Int?#>, weekday: <#T##Int?#>, weekdayOrdinal: <#T##Int?#>, quarter: <#T##Int?#>, weekOfMonth: <#T##Int?#>, weekOfYear: <#T##Int?#>, yearForWeekOfYear: <#T##Int?#>)
//    c.day = 3
//    return c
//  }
}

extension String {
  var dateString: DateString {
    DateString(rawValue: self)
  }
}
