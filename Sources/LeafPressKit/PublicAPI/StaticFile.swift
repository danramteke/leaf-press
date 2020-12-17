import Foundation

public struct StaticFile: Comparable, Equatable {
  public static func < (lhs: StaticFile, rhs: StaticFile) -> Bool {
    lhs.source.rawFilename < rhs.source.rawFilename
  }
  public let slug: String
  public let source: FileLocation
  public let target: FileLocation
  public let relativeUrl: URL
}
