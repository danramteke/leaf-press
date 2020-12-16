import NIO
import Foundation
import PathKit

extension FileLocation {
  func read(with io: NonBlockingFileIO, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
    return Path(self.absolutePath.string).read(with: io, on: eventLoop)
  }

  func write(buffer: ByteBuffer, with io: NonBlockingFileIO, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
    return Path(self.absolutePath.string).write(buffer: buffer, with: io, on: eventLoop)
  }
}
