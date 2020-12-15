import Foundation
import LeafKit

protocol InputFileInitable {
  init(config: Config, inputFile: InputFileMetadata) throws
}

struct InputFileMetadata {
  let metadata: [String: LeafData]
  let source: FileLocation

  var slug: String {
    source.slug
  }

  var isIncluded: Bool {
    guard let draftString = metadata["draft"]?.string else {
      return true
    }

    guard let isDraft = Bool(draftString) else {
      return false
    }

    return !isDraft
  }

  var summary: String? {
    metadata["summary"]?.string
  }

  var dateString: DateString? {
    metadata["date"]?.string?.dateString
  }

  var title: String {
    metadata["title"]?.string ?? "Untitled"
  }

  var template: String? {
    metadata["template"]?.string
  }

  var category: String? {
    metadata["category"]?.string
  }
}

extension InputFileMetadata {
  init(string: String, at fileLocation: FileLocation) throws {
    let metadata = try InputFileParser().metadata(from: string)
    self.init(metadata: metadata, source: fileLocation)
  }
}
