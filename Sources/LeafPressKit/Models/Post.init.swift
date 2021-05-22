import NIO
import Foundation
import MPath

extension Post: InputFileInitable {
  init(config: Config, inputFile: InputFileMetadata) throws {
    let date: Date = try {

      let relativePath = inputFile.source.absolutePath.relative(to: config.postsDir.absolute())
      if let dateFromPath = DateFromDirectoryPath(directoryPath: relativePath) {
        return dateFromPath.date

      } else if let datePrefix = inputFile.source.datePrefix {
        return datePrefix.date

      } else {
        guard let dateString = inputFile.dateString else {
          throw PostInitError(path: inputFile.source.relativeURL.relativeString, message: "doesn't have date. Add a `date` field to the front matter of the post. Frontmatter is YAML at the start of file. A '---' marks the beginning of the frontmatter YAML and a second '---' marks the end of the frontmatter YAML.")
        }

        guard let date = config.date(from: dateString.rawValue) else {
          throw PostInitError(path: inputFile.source.relativeURL.relativeString, message: "couldn't parse date from \(dateString.rawValue)")
        }
        return date
      }
    }()

    let directoryPath: Path = config.postsPublishPrefix + date.pathFragment
    let target = FileLocation(
      root: config.distDir,
      directoryPath: directoryPath,
      slug: inputFile.source.slug,
      fileExtension: SupportedFileType.html.rawValue)

    

    self.init(
      template: inputFile.template ?? "post.leaf",
      slug: inputFile.source.slug,
      title: inputFile.title,
      summary: inputFile.summary,
      source: inputFile.source,
      target: target,
      relativeUrl: target.relativeURL,
      date: date,
      metadata: inputFile.metadata,
      isIncluded: inputFile.isIncluded)
  }

  struct PostInitError: Error, LocalizedError {
    let path: String
    let message: String

    var errorDescription: String? {
      "Path: \(path); error: \(message)"
    }
  }
}
