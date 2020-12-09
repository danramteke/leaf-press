import Foundation
import Foundation
import NIO
import PathKit

public class NewAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func scaffold(dryRun: Bool, date: Date) -> Result<String, Error> {

    let path = config.distDir + config.postsDir
    return .success(path.string)
  }
}

