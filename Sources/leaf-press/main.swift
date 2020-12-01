import Foundation
import ConsoleKit

import ConsoleKit
import Foundation

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: true)

commands.use(BuildCommand(), as: "build", isDefault: true)
commands.use(CleanCommand(), as: "clean", isDefault: false)
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