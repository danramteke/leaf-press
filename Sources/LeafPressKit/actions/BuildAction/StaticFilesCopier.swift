import NIO

class StaticFilesCopier {
  func copy(staticFiles: [StaticFile], in threadPool: NIOThreadPool, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<[Error]> {
    let io = NonBlockingFileIO(threadPool: threadPool)

    let copyFutures = staticFiles
      .map { staticFile in
        staticFile.source.read(with: io, on: eventLoopGroup.next()).flatMap { byteBuffer in
          staticFile.target.write(buffer: byteBuffer, with: io, on: eventLoopGroup.next())
        }
      }

    let multiWait: EventLoopFuture<[Result<Void, Error>]> = EventLoopFuture.whenAllComplete(copyFutures, on: eventLoopGroup.next())
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

  func copyStatics(website: Website, in threadPool: NIOThreadPool, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<[Error]> {
    return self.copy(staticFiles: website.staticFiles, in: threadPool, on: eventLoopGroup)
  }
}
