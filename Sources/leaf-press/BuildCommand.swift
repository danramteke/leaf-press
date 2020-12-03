import ConsoleKit
import LeafPressKit
import PathKit
import Yams
import Foundation

final class BuildCommand: Command {
  struct Signature: CommandSignature {

    @Option(name: "config", short: "c", help: "Custom config file. Default: \(Config.defaultPath)")
    var configFilePath: String?

    @Option(name: "work-dir", short: "w", help: "Custom workspace dir. Defaults to the directory of the config file")
    var workDir: String?

    init() { }
  }

  let help: String = "Build website"

  func run(using context: CommandContext, signature: Signature) throws {


    let configFilePath = signature.configFilePath ?? Config.defaultPath
    context.console.output("using config at \(configFilePath)".consoleText(.info))

    let workDir: Path = {
      if let workDir = signature.workDir {
        return Path(workDir)
      } else {
        return Path(configFilePath).parent()
      }
    }()

    context.console.output("using work dir of config \(workDir.string)".consoleText(.info))

    let config: Config = {
      do {
        let configFileContents: String = try Path(configFilePath).read()

        guard !configFileContents.isEmpty else {
          context.console.output("using default config since config at \(configFilePath) was empty".consoleText(.info))
          return Config.Cli.default
        }

        let decoder = YAMLDecoder()
        let decoded = try decoder.decode(Config.Cli.self, from: configFileContents)
        return Config(cli: decoded, workDir: workDir)
      } catch {
        context.console.error("error parsing config: \(error.localizedDescription)")
        exit(1)
      }
    }()

    BuildAction(config: config).build()
  }
}
