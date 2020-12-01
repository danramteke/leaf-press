import ConsoleKit

final class CleanCommand: Command {
  struct Signature: CommandSignature {
    init() { }
  }

  let help: String = "Clean website"

  func run(using context: CommandContext, signature: Signature) throws {
    context.console.output("not yet implemented".consoleText(.warning))
  }
}
