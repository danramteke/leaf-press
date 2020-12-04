import ConsoleKit
import LeafPressKit
import PathKit
import Yams
import Foundation

final class BuildCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {

    @Option(name: "config", short: "c", help: "Custom config file. Default: \(Config.defaultPath)")
    var configFilePath: String?

    @Option(name: "work-dir", short: "w", help: "Custom workspace dir. Defaults to the directory of the config file")
    var workDir: String?

    @Flag(name: "ignore-static", help: "Don't copy static files")
    var ignoreStatic: Bool
  }

  let help: String = "Build website"

  func run(using context: CommandContext, signature: Signature) throws {

    let config = signature.loadConfig(using: context)

    if signature.ignoreStatic {
      context.console.output("Skipping static files".consoleText(.info))
    }

    let result = BuildAction(config: config).build(ignoreStatic: signature.ignoreStatic)
    switch result {
    case .failure(let error):
      context.console.output("\(error)".consoleText(.error))
    case .success:
      context.console.output("Done".consoleText(.success))
    }
  }
}
