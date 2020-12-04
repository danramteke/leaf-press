import Foundation
import ConsoleKit

func go() {

  let console: Console = Terminal()
  let input = CommandInput(arguments: CommandLine.arguments)
  let context = CommandContext(console: console, input: input)

  var commands = Commands(enableAutocomplete: true)

  commands.use(BuildCommand(), as: "build", isDefault: true)
  commands.use(CleanCommand(), as: "clean", isDefault: false)
  commands.use(InitCommand(), as: "init", isDefault: false)
  commands.use(RoutesCommand(), as: "routes", isDefault: false)
  commands.use(ServeCommand(), as: "serve", isDefault: false)
  commands.use(TodayCommand(), as: "today", isDefault: false)
  do {



    let group = commands
      .group(help: "LeafPress static site generator with Markdown and Leaf templates")
    try console.run(group, input: input)
  } catch let error {
    console.error("\(error)")
    exit(1)
  }
}
go()
