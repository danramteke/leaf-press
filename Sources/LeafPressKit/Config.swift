import Foundation

public struct Config: Codable {
  public let distDir: String
  public let pagesDir: String
  public let postsDir: String
  public let staticFilesDir: String
  public let templatesDir: String
  public init(distDir: String,
              pagesDir: String,
              postsDir: String,
              staticFilesDir: String,
              templatesDir: String) {
    self.distDir = distDir
    self.templatesDir = templatesDir
    self.staticFilesDir = staticFilesDir
    self.postsDir = postsDir
    self.pagesDir = pagesDir
  }
}
