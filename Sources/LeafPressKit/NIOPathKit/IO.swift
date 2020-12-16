import Foundation
import NIO
import PathKit

extension Path {
  public func read(with io: NonBlockingFileIO, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
    let allocator = ByteBufferAllocator()

    return io
      .openFile(path: self.absolute().string, eventLoop: eventLoop)
      .flatMap { handle, region -> EventLoopFuture<ByteBuffer> in
        io.read(fileRegion: region, allocator: allocator, eventLoop: eventLoop)
          .flatMapThrowing { (buffer) -> ByteBuffer in
            try handle.close()
            return buffer
          }
      }
  }

  public func write(buffer: ByteBuffer, with io: NonBlockingFileIO, on eventLoop: EventLoop) -> EventLoopFuture<Void> {

    return self.parent().absolute().makePathAsync(eventLoop: eventLoop).flatMap { _ in

      let flags = NIOFileHandle.Flags.posix(flags: O_CREAT | O_TRUNC,
                                            mode: S_IWUSR | S_IRUSR | S_IRGRP | S_IROTH)
      return io
        .openFile(path: self.absolute().string, mode: .write, flags: flags, eventLoop: eventLoop)
        .flatMap { handle -> EventLoopFuture<Void> in
          io.write(fileHandle: handle, buffer: buffer, eventLoop: eventLoop)
            .flatMapThrowing { _ -> Void in
              try handle.close()
            }
        }
    }
  }
}
