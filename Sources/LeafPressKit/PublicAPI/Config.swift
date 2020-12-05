import Foundation
import PathKit
public struct Config {
  public let distDir: Path
  public let postsPublishPrefix: Path
  public let pagesDir: Path
  public let postsDir: Path
  public let staticFilesDir: Path
  public let templatesDir: Path

  public let publishedDateStyle: DateStyle
  public let publishedTimeStyle: DateStyle?

  public func date(from string: String) -> Date? {
    self.dateFormatter.date(from: string)
  }

  public func string(from date: Date) -> String {
    self.dateFormatter.string(from: date)
  }
  private let dateFormatter: DateFormatter
  public init(distDir: Path,
              postsPublishPrefix: Path,
              pagesDir: Path,
              postsDir: Path,
              staticFilesDir: Path,
              templatesDir: Path,
              publishedDateStyle: DateStyle,
              publishedTimeStyle: DateStyle?) {
    self.distDir = distDir
    self.postsPublishPrefix = postsPublishPrefix
    self.pagesDir = pagesDir
    self.postsDir = postsDir
    self.staticFilesDir = staticFilesDir
    self.templatesDir = templatesDir
    self.publishedDateStyle = publishedDateStyle
    self.publishedTimeStyle = publishedTimeStyle
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = publishedTimeStyle?.style ?? .none
    dateFormatter.dateStyle = publishedDateStyle.style
    self.dateFormatter = dateFormatter
  }

  public enum DateStyle: String, Codable {
    case short, medium, long, full

    var style: DateFormatter.Style {
      switch self {
      case .short: return .short
      case .medium: return .medium
      case .long: return .long
      case .full: return .full
      }
    }
  }
}
