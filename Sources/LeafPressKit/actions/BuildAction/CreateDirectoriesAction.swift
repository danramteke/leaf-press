import Foundation
import MPath

public struct CreateDirectoriesAction {
  let config: Config
  init(config: Config) {
    self.config = config
  }

  public func start() -> Result<Void, Error> {
    return Result {
      try config.distDir.createDirectories()
      try (config.distDir + config.postsPublishPrefix).createDirectories()
    }
  }
}
