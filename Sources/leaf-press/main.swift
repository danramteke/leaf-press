import Foundation
import ConsoleKit

func go() {

  let console: Console = Terminal()
  let input = CommandInput(arguments: CommandLine.arguments)
//  let context = CommandContext(console: console, input: input)

  var commands = Commands(enableAutocomplete: true)
  commands.use(BuildCommand(), as: "build", isDefault: false)
  commands.use(CleanCommand(), as: "clean", isDefault: false)
  commands.use(InitCommand(), as: "init", isDefault: false)
  commands.use(RoutesCommand(), as: "routes", isDefault: false)
  commands.use(ServeCommand(), as: "serve", isDefault: false)
  commands.use(NewCommand(), as: "new", isDefault: false)

  do {
    let group = commands
      .group(help: "LeafPress \(Version())\nA static site generator with Markdown and Leaf templates.\n©2020 Daniel Ramteke, MIT License\nhttps://github.com/danramteke/leaf-press.git")
    try console.run(group, input: input)
  } catch {
    console.error("\(error)")
    exit(1)
  }
}
go()
