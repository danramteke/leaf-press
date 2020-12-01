import ConsoleKit

final class ServeCommand: Command {
  struct Signature: CommandSignature {
    init() { }
  }

  let help: String = "Start a local server to view your site while developing"

  func run(using context: CommandContext, signature: Signature) throws {
    context.console.output("not yet implemented".consoleText(.warning))
  }
}
