import Foundation
import NIO

public class BuildAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func build(skipStatic: Bool, skipScript: Bool, includeDrafts: Bool) -> Result<[Error], Error> {
    return CreateDirectoriesAction(config: config).start()
      .flatMap { _ in
        return self.copyFiles(skipStatic: skipStatic)
          .flatMap { errors in
            self.renderWebsite(includeDrafts: includeDrafts).flatMap { (errors2) -> Result<[Error], Error> in
              return .success(errors + errors2)
            }
          }.flatMap { (errors3) -> Result<[Error], Error> in
            self.runPostBuild(skipScript: skipScript).flatMap { (_) -> Result<[Error], Error> in
              return .success(errors3)
            }
          }
      }
  }

  private func copyFiles(skipStatic: Bool) -> Result<[Error], Error>  {
    return Result {
      return try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) in
        return CopyStaticFilesAction(source: config.staticFilesDir, target: config.distDir)
          .start(skipStatic: skipStatic, eventLoopGroup: eventLoopGroup, threadPool: threadPool)
      }
    }
  }

  private func runPostBuild(skipScript: Bool) -> Result<Void, Error> {
    if skipScript {
      return .success(())
    }
    guard let script = self.config.postBuildScript else {
      return .success(())
    }

    print("running post build script")
    return ScriptAction().start(script: script, workingDirectory: self.config.workDir.string)
  }

  private func renderWebsite(includeDrafts: Bool) -> Result<[Error], Error> {
    return Result {
      try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) in
        return InternalRepresentationLoader(config: config, includeDrafts: includeDrafts)
          .load(threadPool: threadPool, eventLoopGroup: eventLoopGroup)
          .flatMap { website, errors in
            return Renderer(config: self.config)
              .render(website: website, in: threadPool, on: eventLoopGroup.next()).map { _ in
                return errors
              }
          }
      }
    }
  }
}
