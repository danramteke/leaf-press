import Foundation
import MPath

public struct Config {
  public let workDir: Path
  public let distDir: Path
  public let postsPublishPrefix: Path
  public let pagesDir: Path
  public let postsDir: Path
  public let staticFilesDir: Path
  public let templatesDir: Path

  public let publishedDateStyle: DateStyle
  public let publishedTimeStyle: DateStyle?

  public let postBuildScript: String?

  public func date(from string: String) -> Date? {
    self.dateFormatter.date(from: string)
  }

  public func string(from date: Date) -> String {
    self.dateFormatter.string(from: date)
  }
  private let dateFormatter: DateFormatter
  public init(workDir: Path,
              distDir: Path,
              postsPublishPrefix: Path,
              pagesDir: Path,
              postsDir: Path,
              staticFilesDir: Path,
              templatesDir: Path,
              publishedDateStyle: DateStyle,
              publishedTimeStyle: DateStyle?,
              postBuildScript: String?) {
    self.workDir = workDir
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
    self.postBuildScript = postBuildScript
  }

  public var postsPublishDir: Path {
    self.distDir + self.postsPublishPrefix
  }

  public func overridingOutputDir(path: String?) -> Config {
    guard let path = path else {
      return self
    }
    return Config(workDir: self.workDir, distDir: Path(path), postsPublishPrefix: self.postsPublishPrefix, pagesDir: self.pagesDir, postsDir: self.postsDir, staticFilesDir: self.staticFilesDir, templatesDir: self.templatesDir, publishedDateStyle: self.publishedDateStyle, publishedTimeStyle: self.publishedTimeStyle, postBuildScript: self.postBuildScript)
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
