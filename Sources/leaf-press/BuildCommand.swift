import ConsoleKit

final class BuildCommand: Command {
  struct Signature: CommandSignature {
    init() { }
  }

  let help: String = "Build website"

  func run(using context: CommandContext, signature: Signature) throws {
    context.console.output("not yet implemented".consoleText(.warning))
  }
}
