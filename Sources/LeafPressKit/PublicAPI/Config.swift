import Foundation
import PathKit
public struct Config {
  public let distDir: Path
  public let postsPublishPrefix: Path
  public let pagesDir: Path
  public let postsDir: Path
  public let staticFilesDir: Path
  public let templatesDir: Path
  public init(distDir: Path,
              postsPublishPrefix: Path,
              pagesDir: Path,
              postsDir: Path,
              staticFilesDir: Path,
              templatesDir: Path) {
    self.distDir = distDir
    self.postsPublishPrefix = postsPublishPrefix
    self.pagesDir = pagesDir
    self.postsDir = postsDir
    self.staticFilesDir = staticFilesDir
    self.templatesDir = templatesDir
  }
}

extension Config {
  func sourcePath<T: Renderable & InputFileInitable>(for atype: T) -> Path? {
    switch atype {
    case is Post:
      return self.postsDir
    case is Page:
      return self.pagesDir
    default:
      return nil
    }
  }
}
