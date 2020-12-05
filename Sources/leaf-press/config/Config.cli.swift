import LeafPressKit
import PathKit

extension Config {

  static let defaultPath = "./leaf-press.yml"  

  struct Cli: Codable {
    let distDir: String?
    let postsPublishPrefix: String?
    let pagesDir: String?
    let postsDir: String?
    let staticFilesDir: String?
    let templatesDir: String?
    let publishedDateStyle: String?
    let publishedTimeStyle: String?
    let postBuildScript: String?

    static let `default`: Config = .init(
      workDir: "",
      distDir: "dist",
      postsPublishPrefix: "posts",
      pagesDir: "pages",
      postsDir: "posts",
      staticFilesDir: "static",
      templatesDir: "templates",
      publishedDateStyle: .medium,
      publishedTimeStyle: nil,
      postBuildScript: nil)
  }

  init(cli: Cli, workDir: Path) {
    self.init(
      workDir: workDir,
      distDir: workDir.appending(cli.distDir, default: Cli.default.distDir),
      postsPublishPrefix: Path(cli.postsPublishPrefix ?? Cli.default.postsPublishPrefix.string),
      pagesDir: workDir.appending(cli.pagesDir, default: Cli.default.pagesDir),
      postsDir: workDir.appending(cli.postsDir, default: Cli.default.postsDir),
      staticFilesDir: workDir.appending(cli.staticFilesDir, default: Cli.default.staticFilesDir),
      templatesDir: workDir.appending(cli.templatesDir, default: Cli.default.templatesDir),
      publishedDateStyle: cli.publishedDateStyle?.asDateStyle ?? Cli.default.publishedDateStyle,
      publishedTimeStyle: cli.publishedTimeStyle?.asDateStyle ?? Cli.default.publishedTimeStyle,
      postBuildScript: cli.postBuildScript)

  }
}

extension String {
  var asDateStyle: Config.DateStyle? {
    Config.DateStyle(rawValue: self)
  }
}
