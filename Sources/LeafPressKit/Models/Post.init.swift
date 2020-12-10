import NIO
import Foundation
import PathKit

extension Post: InputFileInitable {
  init(config: Config, inputFile: InputFile) throws {
    let directoryPath: Path = config.postsPublishPrefix + Path(inputFile.source.directoryPath)

    let target = FileLocation(
      root: config.distDir.string,
      directoryPath: directoryPath.string,
      rawFilename: inputFile.source.slug + "." + SupportedFileType.html.rawValue,
      slug: inputFile.source.slug,
      fileExtension: SupportedFileType.html.rawValue)

    guard let published = inputFile.published else {
      throw PageInitError(path: inputFile.source.relativeURL.relativeString, message: "doesn't have published date. Add a `published` field to the front matter of the post")
    }

    guard let publishedDate = config.date(from: published.rawValue) else {
      throw PageInitError(path: inputFile.source.relativeURL.relativeString, message: "couldn't parse date from \(published.rawValue)")
    }
    
    self.init(
      template: inputFile.template ?? "post.leaf",
      slug: inputFile.source.slug,
      title: inputFile.title,
      summary: inputFile.summary,
      published: published,
      source: inputFile.source,
      target: target,
      relativeUrl: target.relativeURL,
      publishedDate: publishedDate,
      metadata: inputFile.metadata,
      sha256: inputFile.sha256)
  }

  struct PageInitError: Error {
    let path: String
    let message: String
  }
}
