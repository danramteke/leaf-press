import ConsoleKit
import LeafPressKit

final class RoutesCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {
    @Option(name: Strings.config.name, short: Strings.config.short, help: Strings.config.help)
    var configFilePath: String?

    @Option(name: Strings.workDir.name, short: Strings.workDir.short, help: Strings.workDir.help)
    var workDir: String?

    @Flag(name: "include-static", short: "s", help: "Include routes to static files")
    var includeStatic: Bool
  }

  let help: String = "List all routes currently available, if built now."

  func run(using context: CommandContext, signature: Signature) throws {
    if signature.includeStatic {
      context.console.output("including routes to static files".consoleText(.info))
    }
    
    let result = RoutesAction(config: signature.loadConfig(using: context)).list()

    switch result {
    case .success(let routes):
      context.console.output(routes.joined(separator: "\n").consoleText(.warning))
    case .failure(let error):
      context.console.error(error.localizedDescription)
    }
  }
}
