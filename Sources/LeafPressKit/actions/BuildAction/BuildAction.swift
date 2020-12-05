import Foundation
import NIO

public class BuildAction {
  let config: Config
  public init(config: Config) {
    self.config = config
  }

  public func build(ignoreStatic: Bool) -> Result<Void, Error> {
    Result<Void, Error>.success(())
      .map { _ in
        CreateDirectoriesAction(config: config).start()
      }
      .flatMap { _ -> Result<Void, Error> in
        if ignoreStatic {
          return Result<Void, Error>.success(())
        } else {
          return CopyStaticFilesAction(source: config.staticFilesDir, target: config.distDir).start()
        }
      }
      .flatMap { _ in
        self.renderWebsite()
      }
      .flatMap { _ in
        guard let script = config.postBuildScript else {
          return .success(())
        }

        return self.runPostBuild(script: script)
      }
  }

  private func runPostBuild(script: String) -> Result<Void, Error> {
      print("running post build script")
      return ScriptAction().start(script: script, workingDirectory: self.config.workDir.string)
  }

  private func renderWebsite() -> Result<Void, Error> {
    return Result {
      try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) in
        return InternalRepresentationLoader(config: config)
          .load(threadPool: threadPool, eventLoopGroup: eventLoopGroup)
          .flatMap { (website) in
            return Renderer(config: self.config).render(website: website, in: threadPool, on: eventLoopGroup.next())
          }
      }
    }
  }
}
