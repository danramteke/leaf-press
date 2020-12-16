import Foundation
import NIO

public class BuildAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func build(skipStatic: Bool, skipScript: Bool, includeDrafts: Bool) -> Result<[Error], Error> {
    Result<[Error], Error>.success([])
      .map { _ in
        CreateDirectoriesAction(config: config).start()
      }
      .flatMap { _ -> Result<Void, Error> in
        if skipStatic {
          return Result<Void, Error>.success(())
        } else {
          return Result {
            try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) in
              return CopyStaticFilesAction(source: config.staticFilesDir, target: config.distDir).start(eventLoopGroup: eventLoopGroup)
            }
          }

        }
      }
      .flatMap { _ in
        self.renderWebsite(includeDrafts: includeDrafts)
      }
      .flatMap { errors in
        guard !skipScript, let script = config.postBuildScript else {
          return .success([])
        }

        return self.runPostBuild(script: script).map { _  in
          return errors
        }
      }
  }

  private func runPostBuild(script: String) -> Result<Void, Error> {
      print("running post build script")
      return ScriptAction().start(script: script, workingDirectory: self.config.workDir.string)
  }

  private func renderWebsite(includeDrafts: Bool) -> Result<[Error], Error> {
    return Result {
      try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) in
        return InternalRepresentationLoader(config: config, includeDrafts: includeDrafts)
          .load(threadPool: threadPool, eventLoopGroup: eventLoopGroup)
          .flatMap { website, errors in
            return Renderer(config: self.config).render(website: website, in: threadPool, on: eventLoopGroup.next()).map { _ in
              return errors
            }
          }
      }
    }
  }
}
