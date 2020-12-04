import Foundation
import ConsoleKit

final class InitCommand: Command {
  struct Signature: CommandSignature {
    init() { }
  }

  let help: String = "Initialize a new website"

  func run(using context: CommandContext, signature: Signature) throws {
    context.console.output("not yet implemented".consoleText(.warning))
  }
}
