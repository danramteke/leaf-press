import ConsoleKit
import LeafPressKit

final class CleanCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {
    @Option(name: Strings.config.name, short: Strings.config.short, help: Strings.config.help)
    var configFilePath: String?

    @Option(name: Strings.workDir.name, short: Strings.workDir.short, help: Strings.workDir.help)
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
