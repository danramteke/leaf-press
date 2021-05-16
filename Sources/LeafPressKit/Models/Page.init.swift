import Foundation
import NIO

extension Page: InputFileInitable {
  init(config: Config, inputFile: InputFileMetadata) {
    let target = FileLocation(
      root: config.distDir.string,
      directoryPath: inputFile.source.directoryPath,
      slug: inputFile.source.slug,
      fileExtension: SupportedFileType.html.rawValue)


    let metadataDate: Date? = {
      guard let dateString = inputFile.metadata["date"]?.string else {
        return nil
      }

      return config.date(from: dateString)
    }()

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
      category: inputFile.category,
      date: metadataDate)
  }
}
