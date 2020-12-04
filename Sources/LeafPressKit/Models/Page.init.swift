import Foundation
import NIO

extension Page {
  init?(config: Config, inputFile: InputFile) {
    let target = FileLocation(root: config.distDir.string, directoryPath: inputFile.source.directoryPath, slug: inputFile.source.slug, fileType: .html, publishType: .page)

    self.init(slug: inputFile.source.slug,
              title: inputFile.title,
              summary: inputFile.summary,
              source: inputFile.source,
              target: target,
              relativeUrl: target.relativeURL)
  }
}
