import Foundation
import PathKit
import NIO

struct InputFile {

//  let rawValue: String
  let frontMatter: [String: String]
  let source: FileLocation
  let target: FileLocation

  var fileType: FileType {
    source.fileType
  }

  var slug: String {
    source.slug
  }
  
  var summary: String? {
    frontMatter["summary"]
  }

  var published: DateString? {
    frontMatter["published"]?.dateString
  }

  var publishType: PublishType {
    source.publishType
  }
}

extension InputFile {
  init(buffer: ByteBuffer) {
 fatalError()
  }
}

protocol InputFileInitable {
  init?(inputFile: InputFile)
}
