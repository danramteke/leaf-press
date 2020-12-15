import Foundation
import ConsoleKit
import LeafPressKit
import PathKit

final class InitCommand: Command {
  struct Signature: CommandSignature {
    @Flag(name: "dry-run", help: "Print the files that would be created, but don't create them.")
    var dryRun: Bool

    @Option(name: Strings.workDir.name, short: Strings.workDir.short, help: "Directory to create files. Defaults to current directory.")
    var workDir: String?
  }

  let help: String = "Initialize a new website"

  func run(using context: CommandContext, signature: Signature) throws {

    let workDir: Path = {
      guard let workDir = signature.workDir else {
        return Path.current
      }
      return Path(workDir).normalize()
    }()

    let result = InitAction(workDir: workDir).scaffold(dryRun: signature.dryRun)
    switch result {
    case .success(let paths):
      if signature.dryRun {
        context.console.output("Would create".consoleText(.success))
      } else {
        context.console.output("Created".consoleText(.success))
      }
      for path in paths {
        context.console.output("\(path)".consoleText(.plain))
      }
    case .failure(let error):
      context.console.output("\(error)".consoleText(.error))
    }
  }
}
