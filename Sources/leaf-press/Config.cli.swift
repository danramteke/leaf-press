import LeafPressKit
import PathKit

extension Config {

  static let defaultPath = "./leaf-press.yml"  



  public struct Cli: Codable {
    public let distDir: String?
    public let pagesDir: String?
    public let postsDir: String?
    public let staticFilesDir: String?
    public let templatesDir: String?
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
    static let `default`: Config = .init(
      distDir: "dist",
      pagesDir: "pages",
      postsDir: "posts",
      staticFilesDir: "static",
      templatesDir: "templates")
  }

  init(cli: Cli, workDir: Path) {
    self.init(distDir: workDir.appending(cli.distDir, default: Cli.default.distDir),
              pagesDir: workDir.appending(cli.pagesDir, default: Cli.default.pagesDir),
              postsDir: workDir.appending(cli.postsDir, default: Cli.default.postsDir),
              staticFilesDir: workDir.appending(cli.staticFilesDir, default: Cli.default.staticFilesDir),
              templatesDir: workDir.appending(cli.templatesDir, default: Cli.default.templatesDir))
  }
}

