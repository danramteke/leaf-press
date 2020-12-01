import ConsoleKit
import LeafPressKit

final class BuildCommand: Command {
  struct Signature: CommandSignature {

    @Option(name: "config", short: "c", help: "Custom config file. Default: \(Config.defaultPath)")
    var configFilePath: String?
    init() { }
  }

  let help: String = "Build website"

  func run(using context: CommandContext, signature: Signature) throws {
    let configFilePath = signature.configFilePath ?? Config.defaultPath
    context.console.output("using config at \(configFilePath)".consoleText(.info))
    context.console.output("not yet implemented".consoleText(.warning))
  }
}
