import ConsoleKit
import LeafPressKit

final class CleanCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {

    @Option(name: "config", short: "c", help: "Custom config file. Default: \(Config.defaultPath)")
    var configFilePath: String?

    @Option(name: "work-dir", short: "w", help: "Custom workspace dir. Defaults to the directory of the config file")
    var workDir: String?
  }

  let help: String = "Clean website"

  func run(using context: CommandContext, signature: Signature) throws {
    let config = signature.loadConfig(using: context)

    let result = CleanAction(config: config).clean()
    switch result {
    case .failure(let error):
      context.console.output("\(error)".consoleText(.error))
    case .success:
      context.console.output("Done".consoleText(.success))
    }
  }
}
