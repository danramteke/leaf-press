import MPath
import Foundation
import NIO

public class CleanAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func clean() -> Result<Void, Error> {
    return Result {
      try self.config.distDir.delete()
    }
  }
}
