import Foundation
import PathKit
import NIO

public struct CopyStaticFilesAction {
  let source: String
  let target: String
  init(source: Path, target: Path) {
    let absoluteSource = source.absolute().string
    if absoluteSource.hasSuffix("/") {
      self.source = absoluteSource
    } else {
      self.source = absoluteSource + "/"
    }

    self.target = target.absolute().string
  }


  private func copyAsync(sourcePath: Path, targetPath: Path, on eventLoopGroup: EventLoopGroup, threadPool: NIOThreadPool ) -> EventLoopFuture<Void> {
    let io = NonBlockingFileIO(threadPool: threadPool)
    return sourcePath.read(with: io, on: eventLoopGroup.next()).flatMap { buffer in
      targetPath.write(buffer: buffer, with: io, on: eventLoopGroup.next())
    }
  }

  public func start(skipStatic: Bool, eventLoopGroup: EventLoopGroup, threadPool: NIOThreadPool) -> EventLoopFuture<[Error]> {
    if skipStatic {
      return eventLoopGroup.next().makeSucceededFuture([])
    }
    let sourceRoot = Path(source)
    let targetRoot = Path(target)
    return sourceRoot
      .recursiveChildrenAsync(eventLoop: eventLoopGroup.next())
      .flatMap { (sourcePaths) -> EventLoopFuture<[Error]> in
        let futures: [EventLoopFuture<Void>] = sourcePaths
          .map { sourcePath -> EventLoopFuture<Void> in
            sourcePath.isDirectoryAsync(eventLoop: eventLoopGroup.next()).flatMap { (isDirectory) -> EventLoopFuture<Void> in
              if isDirectory {
                return eventLoopGroup.next().makeSucceededFuture(())
              } else {
                let relativePath = sourcePath.relative(to: sourceRoot)
                let targetPath = targetRoot + relativePath
                return self.copyAsync(sourcePath: sourcePath,
                                      targetPath: targetPath,
                                      on: eventLoopGroup,
                                      threadPool: threadPool)
              }
            }
          }

        let multiWait: EventLoopFuture<[Result<Void, Error>]> = EventLoopFuture.whenAllComplete(futures, on: eventLoopGroup.next())
        return multiWait.map { (a: [Result<Void, Error>]) -> [Error] in
          a.compactMap { (c: Result<Void, Error>) -> Error? in
            switch c {
            case .failure(let error):
              return error
            case .success(_):
                  return nil
            }
          }
        }
      }

  }
}

