import NIO
import Foundation

struct MultiThreadedContext<ReturnType> {
  func run(block: (EventLoopGroup, NIOThreadPool) -> EventLoopFuture<ReturnType>) throws -> ReturnType {
    let eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 3)
    let threadPool = NIOThreadPool(numberOfThreads: 3)
    threadPool.start()

    let flag = block(eventLoopGroup, threadPool)

    let returnValue = try flag.wait()
    try eventLoopGroup.syncShutdownGracefully()
    try threadPool.syncShutdownGracefully()

    return returnValue
  }
}
