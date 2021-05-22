import ConsoleKit
import LeafPressKit
import MPath
import Yams
import Foundation

final class BuildCommand: Command {
  struct Signature: CommandSignature, ConfigLoading {

    @Option(name: Strings.config.name, short: Strings.config.short, help: Strings.config.help)
    var configFilePath: String?

    @Option(name: Strings.workDir.name, short: Strings.workDir.short, help: Strings.workDir.help)
    var workDir: String?

    @Flag(name: "skip-static", help: "Don't copy static files")
    var skipStatic: Bool

    @Flag(name: "skip-script", help: "Don't copy static files")
    var skipScript: Bool

    @Flag(name: "watch", help: "Watch the paths and rebuild the site as its modified.")
    var watch: Bool

    @Flag(name: "include-drafts", help: "Include routes to drafts")
    var includeDrafts: Bool

    @Option(name: "override-output-dir", help: "Override output directory specified by leaf-press.yml. This is useful when deploying to GitLab Pages, which requires a specific directory.")
    var overrideOutputDir: String?
  }

  let help: String = "Build website"

  func run(using context: CommandContext, signature: Signature) throws {

    let config = signature.loadConfig(using: context).overridingOutputDir(path: signature.overrideOutputDir)

    if signature.skipStatic {
      context.console.output("Skipping static files".consoleText(.info))
    }

    if signature.skipScript {
      context.console.output("Skipping scripts".consoleText(.info))
    }

    if signature.watch {
      context.console.output("--watch is not yet implemented".consoleText(.info))
    }

    let result = BuildAction(config: config)
      .build(skipStatic: signature.skipStatic, skipScript: signature.skipScript, includeDrafts: signature.includeDrafts)
    switch result {
    case .failure(let error):
      context.console.output("\(error.localizedDescription)".consoleText(.error))
    case .success(let errors):
      context.console.output("Done".consoleText(.success))
      if !errors.isEmpty {
        context.console.output("However, the following errors occured: ")
        for (i, error) in errors.enumerated() {
          context.console.info("\(i).")
          context.console.error(error.localizedDescription)
          context.console.error("")
        }
      }
    }
  }
}
