import Foundation
import ConsoleKit
import LeafPressKit

final class NewCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {
    @Option(name: Strings.config.name, short: Strings.config.short, help: Strings.config.help)
    var configFilePath: String?

    @Option(name: Strings.workDir.name, short: Strings.workDir.short, help: Strings.workDir.help)
    var workDir: String?
  }

  let help: String = "Start a new blog-post for today's date"

  func run(using context: CommandContext, signature: Signature) throws {
    let result = NewAction(config: signature.loadConfig(using: context)).scaffold(dryRun: false, date: Date())
    switch result {
    case .failure(let error):
      context.console.error(error.localizedDescription)
    case .success(let path):
      context.console.success("created new post at \(path)")
    }
  }
}
