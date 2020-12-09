import Foundation
import ConsoleKit
import LeafPressKit
import PathKit
import Yams

protocol ConfigLoading {
  var workDir: String? { get }
  var configFilePath: String? { get }

  func loadConfig(using context: CommandContext) -> Config
}

extension ConfigLoading {
  func loadConfig(using context: CommandContext) -> Config {
    let configFilePath = self.configFilePath ?? Config.defaultPath

    let workDir: Path = {
      if let workDir = self.workDir {
        return Path(workDir)
      } else {
        return Path(configFilePath).parent()
      }
    }()

    context.console.output("using config at \(configFilePath), work dir at \(workDir.string)".consoleText(.info))

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

    return config
  }
}
