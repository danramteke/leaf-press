import Foundation
import ConsoleKit
import LeafPressKit

enum Strings {
  static let workDir = OptionValues(name: "work-dir", short: "w", help: "Custom workspace dir. Defaults to the directory of the config file")
  static let config = OptionValues(name: "config", short: "c", help: "Custom config file. Default: \(Config.defaultPath)")
}

struct OptionValues {
  let name: String
  let short: Character
  let help: String
}
