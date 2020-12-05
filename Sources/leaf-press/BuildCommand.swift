import ConsoleKit
import LeafPressKit
import PathKit
import Yams
import Foundation

final class BuildCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {

    @Option(name: Strings.config.name, short: Strings.config.short, help: Strings.config.help)
    var configFilePath: String?

    @Option(name: Strings.workDir.name, short: Strings.workDir.short, help: Strings.workDir.help)
    var workDir: String?

    @Flag(name: "ignore-static", help: "Don't copy static files")
    var ignoreStatic: Bool

    @Flag(name: "watch", help: "Watch the paths and rebuild the site as its modified.")
    var watch: Bool
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
