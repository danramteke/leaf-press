import Foundation
import PathKit
public struct Config {
  public let distDir: Path
  public let distPostDir: Path
  public let pagesDir: Path
  public let postsDir: Path
  public let staticFilesDir: Path
  public let templatesDir: Path
  public init(distDir: Path,
              distPostDir: Path,
              pagesDir: Path,
              postsDir: Path,
              staticFilesDir: Path,
              templatesDir: Path) {
    self.distDir = distDir
    self.distPostDir = distPostDir
    self.pagesDir = pagesDir
    self.postsDir = postsDir
    self.staticFilesDir = staticFilesDir
    self.templatesDir = templatesDir
  }
}
