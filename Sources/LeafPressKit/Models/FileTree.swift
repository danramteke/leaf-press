import Foundation
import PathKit
import NIO

class FileTree {
  let fileLocations: [FileLocation]
  init(root: Path, publishType: PublishType) {
    self.fileLocations = root.glob(FileType.glob).compactMap { (childPath) -> FileLocation? in
      FileLocation(path: childPath.absolute(), root: root, publishType: publishType)
    }
  }

  func load(in threadPool: NIOThreadPool, on eventLoop: EventLoop) -> [EventLoopFuture<InputFile>] {
    let io = NonBlockingFileIO(threadPool: threadPool)


    return self.fileLocations.map { (location) -> EventLoopFuture<InputFile> in
      location.read(with: io, on: eventLoop).map { (buffer) -> InputFile in
        return InputFile(buffer: buffer, at: location)
      }
    }
  }
}
