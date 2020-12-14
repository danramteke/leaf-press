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

    @Flag(name: "include-drafts", help: "Include routes to drafts")
    var includeDrafts: Bool
  }

  let help: String = "List all routes currently available, if built now."

  func run(using context: CommandContext, signature: Signature) throws {
    if signature.includeStatic {
      context.console.output("including routes to static files".consoleText(.info))
    }
    
    let result = RoutesAction(config: signature.loadConfig(using: context)).list(includeDrafts: signature.includeDrafts)

    switch result {
    case .success(let success):
      let errors = success.1
      let routes = success.0
      context.console.output(routes.joined(separator: "\n").consoleText(.info))
      if !errors.isEmpty {
        context.console.output("However, the following errors occured: ")
        for (i, error) in errors.enumerated() {
          context.console.info("\(i).")
          context.console.error(error.localizedDescription)
          context.console.error("")
        }
      }
    case .failure(let error):
      context.console.error(error.localizedDescription)
    }
  }
}
