import Foundation
import PathKit

struct PageIR {
  typealias Id = Tagged<PageIR, String>
  let slug: Id
  let title: String
  let summary: String

  let destination: Path
}
