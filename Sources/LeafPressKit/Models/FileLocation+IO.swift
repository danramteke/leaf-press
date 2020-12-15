import NIO
import Foundation
import PathKit

extension FileLocation {
  func read(with io: NonBlockingFileIO, on eventLoop: EventLoop) -> EventLoopFuture<ByteBuffer> {
    let allocator = ByteBufferAllocator()

    return io
      .openFile(path: self.absolutePath.string, eventLoop: eventLoop)
      .flatMap { handle, region -> EventLoopFuture<ByteBuffer> in
        io.read(fileRegion: region, allocator: allocator, eventLoop: eventLoop)
          .flatMapThrowing { (buffer) -> ByteBuffer in
            try handle.close()
            return buffer
          }
      }
  }

  func write(buffer: ByteBuffer, with io: NonBlockingFileIO, on eventLoop: EventLoop) -> EventLoopFuture<Void> {

    return self.absolutePath.parent().absolute().makePathAsync(eventLoop: eventLoop).flatMap { _ in

      let flags = NIOFileHandle.Flags.posix(flags: O_CREAT | O_TRUNC,
                                            mode: S_IWUSR | S_IRUSR | S_IRGRP | S_IROTH)
      return io
        .openFile(path: self.absolutePath.string, mode: .write, flags: flags, eventLoop: eventLoop)
        .flatMap { handle -> EventLoopFuture<Void> in
          io.write(fileHandle: handle, buffer: buffer, eventLoop: eventLoop)
            .flatMapThrowing { _ -> Void in
              try handle.close()
            }
        }
    }
  }
}
