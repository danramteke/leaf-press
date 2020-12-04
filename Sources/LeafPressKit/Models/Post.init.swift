import NIO
import Foundation

extension Post: InputFileInitable {
  init?(config: Config, inputFile: InputFile) {

    let target = FileLocation(root: config.distDir.string, directoryPath: inputFile.source.directoryPath, slug: inputFile.source.slug, fileType: .html, publishType: .post)

    self.init(slug: inputFile.source.slug,
              title: inputFile.title,
              summary: inputFile.summary,
              published: inputFile.published,
              source: inputFile.source,
              target: target,
              relativeUrl: target.relativeURL)
    
  }
}
