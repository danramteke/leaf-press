import Foundation
import NIO

extension Page: InputFileInitable {
  init(config: Config, inputFile: InputFile) {
    let target = FileLocation(
      root: config.distDir.string,
      directoryPath: inputFile.source.directoryPath,
      rawFilename: inputFile.source.slug + "." + SupportedFileType.html.rawValue,
      slug: inputFile.source.slug,
      fileExtension: SupportedFileType.html.rawValue)

    self.init(
      template: inputFile.template ?? "page.leaf",
      slug: inputFile.source.slug,
      title: inputFile.title,
      summary: inputFile.summary,
      source: inputFile.source,
      target: target,
      relativeUrl: target.relativeURL,
      metadata: inputFile.metadata,
      isIncluded: inputFile.isIncluded,
      sha256: inputFile.sha256)
  }
}
