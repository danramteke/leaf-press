import Foundation
import Foundation
import NIO
import MPath

public class NewAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func scaffold(dryRun: Bool, date: Date) -> Result<String, Error> {

    let path = config.distDir + config.postsDir
    let dateString = config.string(from: date)
    let content = self.newContent(dateString: dateString)

    if !dryRun {
      do {
        try path.write(content, encoding: .utf8)
      } catch {
        return .failure(error)
      }
    }
    return .success(path.string)
  }

  func newContent(dateString: String) -> String {
    """
    ---
    title: New Post on \(dateString)
    date: \(dateString)
    ---
    # New Post on \(dateString)

    Today I wrote a blog post.
    """
  }
}
