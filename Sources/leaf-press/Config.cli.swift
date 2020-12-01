import LeafPressKit

extension Config {

  static let defaultPath = "leaf-press.yml"  

  static let `default`: Config = .init(
    distDir: "dist",
    pagesDir: "templates",
    postsDir: "static",
    staticFilesDir: "posts",
    templatesDir: "pages"
  )
}
