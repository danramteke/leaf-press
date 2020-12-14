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

    guard let dateString = inputFile.dateString else {
      throw PageInitError(path: inputFile.source.relativeURL.relativeString, message: "doesn't have date. Add a `date` field to the front matter of the post")
    }

    guard let date = config.date(from: dateString.rawValue) else {
      throw PageInitError(path: inputFile.source.relativeURL.relativeString, message: "couldn't parse date from \(dateString.rawValue)")
    }
    
    self.init(
      template: inputFile.template ?? "post.leaf",
      slug: inputFile.source.slug,
      title: inputFile.title,
      summary: inputFile.summary,
      dateString: dateString,
      source: inputFile.source,
      target: target,
      relativeUrl: target.relativeURL,
      date: date,
      metadata: inputFile.metadata,
      isIncluded: inputFile.isIncluded,
      sha256: inputFile.sha256)
  }

  struct PageInitError: Error {
    let path: String
    let message: String
  }
}
