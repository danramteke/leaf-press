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
        self.renderWebsite(includeDrafts: includeDrafts, includeStatic: !skipStatic)
          .flatMap { (errors2) -> Result<[Error], Error> in
            return .success(errors2)
          }
      }.flatMap { (errors3) -> Result<[Error], Error> in
        self.runPostBuild(skipScript: skipScript)
          .flatMap { (_) -> Result<[Error], Error> in
            return .success(errors3)
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

  private func renderWebsite(includeDrafts: Bool, includeStatic: Bool) -> Result<[Error], Error> {
    return Result {
      try MultiThreadedContext(numberOfThreads: 3).run { (eventLoopGroup, threadPool) in
        return InternalRepresentationLoader(config: config, includeDrafts: includeDrafts, includeStatic: includeStatic)
          .load(threadPool: threadPool, eventLoopGroup: eventLoopGroup)
          .flatMap { website, errors in

            let copyerFuture = StaticFilesCopier()
              .copyStatics(website: website, in: threadPool, on: eventLoopGroup)

            let rendererFuture = Renderer(config: self.config)
              .render(website: website, in: threadPool, on: eventLoopGroup)

            return copyerFuture.and(rendererFuture).map { (copierErrors, _) in
                return errors + copierErrors
              }
          }
      }
    }
  }
}
