import Foundation
import PathKit

struct PostIR {
  typealias Id = Tagged<PostIR, String>
  let slug: Id
  let title: String
  let summary: String
  
  let published: DateString

  let destination: Path
}
