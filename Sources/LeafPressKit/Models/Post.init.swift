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
    
    self.init(
      template: "post.leaf",
      slug: inputFile.source.slug,
      title: inputFile.title,
      summary: inputFile.summary,
      published: inputFile.published,
      source: inputFile.source,
      target: target,
      relativeUrl: target.relativeURL)
    
  }
}
