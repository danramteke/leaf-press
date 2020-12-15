
import ConsoleKit

final class VersionCommand: Command {
  struct Signature: CommandSignature { }

  let help: String = "Print current version: \(version)"

  func run(using context: CommandContext, signature: Signature) throws {
    context.console.output(version.consoleText(.plain))
  }
}
