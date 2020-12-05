import NIO
import Foundation

struct MultiThreadedContext {
  let numberOfThreads: Int
  init(numberOfThreads: Int) {
    self.numberOfThreads = numberOfThreads
  }

  func run<ReturnType>(block: (EventLoopGroup, NIOThreadPool) -> EventLoopFuture<ReturnType>) throws -> ReturnType {
    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: numberOfThreads)
    let threadPool = NIOThreadPool(numberOfThreads: numberOfThreads)
    threadPool.start()

    let flag = block(eventLoopGroup, threadPool)

    let returnValue = try flag.wait()
    try eventLoopGroup.syncShutdownGracefully()
    try threadPool.syncShutdownGracefully()

    return returnValue
  }
}
