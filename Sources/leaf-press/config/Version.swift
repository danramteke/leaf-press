import Foundation
import PathKit
struct Version {
  let string: String = try! (Path(Bundle.module.resourcePath!) + Path("version/version.txt")).read()
}

extension Version: CustomStringConvertible {
  var description: String {
    string
  }
}
