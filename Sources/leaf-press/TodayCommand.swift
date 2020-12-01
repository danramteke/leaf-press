import ConsoleKit

final class TodayCommand: Command {
  struct Signature: CommandSignature {
    init() { }
  }

  let help: String = "Start a new blog-post for today's date"

  func run(using context: CommandContext, signature: Signature) throws {
    context.console.output("not yet implemented".consoleText(.warning))
  }
}
