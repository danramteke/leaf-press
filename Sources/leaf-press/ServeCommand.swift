import ConsoleKit

final class ServeCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {
    @Option(name: Strings.config.name, short: Strings.config.short, help: Strings.config.help)
    var configFilePath: String?

    @Option(name: Strings.workDir.name, short: Strings.workDir.short, help: Strings.workDir.help)
    var workDir: String?
  }

  let help: String = "Start a local server to view your site while developing"

  func run(using context: CommandContext, signature: Signature) throws {
    let config = signature.loadConfig(using: context)
    context.console.output("Not yet implemented. For now use:".consoleText(.warning))
    context.console.output("docker run -p 8080:80 -v \(config.distDir.string):/usr/share/nginx/html/ nginx".consoleText(.info))
  }
}
