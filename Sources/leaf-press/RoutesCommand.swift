import ConsoleKit

final class RoutesCommand: Command {
  struct Signature: CommandSignature {
    @Flag(name: "include-static", short: "s", help: "Include routes to static files")
    var includeStatic: Bool
    init() { }
  }

  let help: String = "List all routes currently available, if built now."

  func run(using context: CommandContext, signature: Signature) throws {
    if signature.includeStatic {
    context.console.output("including routes to static files".consoleText(.info))  
    } 
    context.console.output("not yet implemented".consoleText(.warning))
  }
}
