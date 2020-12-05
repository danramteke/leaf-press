import Foundation
import PathKit

public struct CreateDirectoriesAction {
  let config: Config
  init(config: Config) {
    self.config = config
  }

  public func start() -> Result<Void, Error> {
    return Result {
      try config.distDir.mkpath()
      try (config.distDir + config.postsPublishPrefix).mkpath()
    }
  }
}
