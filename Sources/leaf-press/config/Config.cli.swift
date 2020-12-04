import LeafPressKit
import PathKit

extension Config {

  static let defaultPath = "./leaf-press.yml"  

  struct Cli: Codable {
    let distDir: String?
    let distPostDir: String?
    let pagesDir: String?
    let postsDir: String?
    let staticFilesDir: String?
    let templatesDir: String?
    init(distDir: String,
         distPostDir: String,
                pagesDir: String,
                postsDir: String,
                staticFilesDir: String,
                templatesDir: String) {
      self.distDir = distDir
      self.distPostDir = distPostDir
      self.templatesDir = templatesDir
      self.staticFilesDir = staticFilesDir
      self.postsDir = postsDir
      self.pagesDir = pagesDir
    }
    static let `default`: Config = .init(
      distDir: "dist",
      distPostDir: "dist/posts",
      pagesDir: "pages",
      postsDir: "posts",
      staticFilesDir: "static",
      templatesDir: "templates")
  }

  init(cli: Cli, workDir: Path) {
    self.init(distDir: workDir.appending(cli.distDir, default: Cli.default.distDir),
              distPostDir: workDir.appending(cli.distPostDir, default: Cli.default.distPostDir),
              pagesDir: workDir.appending(cli.pagesDir, default: Cli.default.pagesDir),
              postsDir: workDir.appending(cli.postsDir, default: Cli.default.postsDir),
              staticFilesDir: workDir.appending(cli.staticFilesDir, default: Cli.default.staticFilesDir),
              templatesDir: workDir.appending(cli.templatesDir, default: Cli.default.templatesDir))
  }
}

