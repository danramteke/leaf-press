import NIO
import Foundation
import PathKit

extension Post: InputFileInitable {
  init?(config: Config, inputFile: InputFile) {
    let directoryPath: Path = config.postsPublishPrefix + Path(inputFile.source.directoryPath)

    let target = FileLocation(
      root: config.distDir.string,
      directoryPath: directoryPath.string,
      slug: inputFile.source.slug,
      fileType: .html)

    guard let published = inputFile.published else {
      print("skipping \(inputFile.source.relativeURL.relativeString) - doesn't have published date")
      // TODO: convert to throwing error
      return nil
    }

    guard let publishedDate = config.date(from: published.rawValue) else {
      print("skipping \(inputFile.source.relativeURL.relativeString) - couldn't parse date from \(published.rawValue)")
      // TODO: convert to throwing error
      return nil
    }
    
    self.init(
      template: "post.leaf",
      slug: inputFile.source.slug,
      title: inputFile.title,
      summary: inputFile.summary,
      published: published,
      source: inputFile.source,
      target: target,
      relativeUrl: target.relativeURL,
      publishedDate: publishedDate)
    
  }
}
