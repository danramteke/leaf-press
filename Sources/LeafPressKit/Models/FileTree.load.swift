import NIO
import Foundation

extension FileTree {
  func load(in threadPool: NIOThreadPool, on eventLoop: EventLoop) -> [EventLoopFuture<InputFile>] {
    let io = NonBlockingFileIO(threadPool: threadPool)


    return self.fileLocations.map { (location) -> EventLoopFuture<InputFile> in
      location.read(with: io, on: eventLoop).map { (buffer) -> InputFile in
        return InputFile(buffer: buffer, at: location)
      }
    }


//    .map { (pairs) in
//      Dictionary(uniqueKeysWithValues: pairs(
//    }


  }
}
