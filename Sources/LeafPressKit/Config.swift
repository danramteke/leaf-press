import Foundation
import PathKit
public struct Config {
  public let distDir: Path
  public let pagesDir: Path
  public let postsDir: Path
  public let staticFilesDir: Path
  public let templatesDir: Path
  public init(distDir: Path,
              pagesDir: Path,
              postsDir: Path,
              staticFilesDir: Path,
              templatesDir: Path) {
    self.distDir = distDir
    self.pagesDir = pagesDir
    self.postsDir = postsDir
    self.staticFilesDir = staticFilesDir
    self.templatesDir = templatesDir
  }
}
