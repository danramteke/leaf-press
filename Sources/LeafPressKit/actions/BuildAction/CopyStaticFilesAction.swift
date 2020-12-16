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


  private func copyAsync(sourcePath: Path, targetPath: Path, on eventLoop: EventLoop) -> EventLoopFuture<Result<Void, Error>> {
    //    let relativePath = sourcePath.relative(to: sourceRoot)
    //          let targetPath = targetRoot + relativePath
    //    let sourceLocation = FileLocation(path: relativePath, root: sourceRoot)
    //    let targetLocation = FileLocation(path: relativePath, root: targetRoot)
    eventLoop.makeSucceededFuture(.success(()))
  }

  public func start(eventLoopGroup: EventLoopGroup) -> EventLoopFuture<[Error]> {

    let sourceRoot = Path(source)
    let targetRoot = Path(target)
    return sourceRoot
      .recursiveChildrenAsync(eventLoop: eventLoopGroup.next())
      .flatMap { (sourcePaths) -> EventLoopFuture<[Error]> in
        let futures: [EventLoopFuture<Result<Void, Error>>] = sourcePaths
          .map { sourcePath -> EventLoopFuture<Result<Void, Error>> in
            let relativePath = sourcePath.relative(to: sourceRoot)
            let targetPath = targetRoot + relativePath
            let sourceLocation = FileLocation(path: relativePath, root: sourceRoot)
            let targetLocation = FileLocation(path: relativePath, root: targetRoot)

            //          sourceLocation.

            return self.copyAsync(sourcePath: sourcePath, targetPath: targetPath, on: eventLoopGroup.next())
          }

        let multiWait: EventLoopFuture<[Result<Result<Void, Error>, Error>]> = EventLoopFuture.whenAllComplete(futures, on: eventLoopGroup.next())
        return multiWait.map { (a: [Result<Result<Void, Error>, Error>]) -> [Error] in
          a.compactMap { (c: Result<Result<Void, Error>, Error>) -> Error? in
            return nil
//            c.map { (d: Result<Void, Error>) -> Error? in
//              d.mapError { (error) -> Error in
//                error
//              }
//            }
          }
        }
      }

  }

//  public struct Error: Swift.Error, LocalizedError {
//    public let terminationStatus: Int32
//    let stdErrData: Data
//
//    public var errorDescription: String? {
//      "CopyStaticFilesError \(terminationStatus): " + (String(data: stdErrData, encoding: .utf8) ?? "")
//    }
//  }
}

