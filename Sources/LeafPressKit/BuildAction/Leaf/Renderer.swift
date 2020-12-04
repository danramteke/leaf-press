import Foundation
import NIO
import LeafKit
import PathKit

class Renderer {
  let config: Config

  
  init(config: Config) {
    self.config = config
  }
  func render(website: Website, in threadPool: NIOThreadPool, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
    let io = NonBlockingFileIO(threadPool: threadPool)

    let templatesDir = config.templatesDir.absolute().string
    let leafConfig = LeafConfiguration(rootDirectory: templatesDir)
    let sources = LeafSources.singleSource(NIOLeafFiles(fileio: io, sandboxDirectory: templatesDir, viewDirectory: templatesDir))
    let leafRenderer = LeafRenderer(
      configuration: leafConfig,
      sources: sources,
      eventLoop: eventLoop
    )

    let futures: [EventLoopFuture<Void>] = website.pages.map { (page) -> EventLoopFuture<Void> in
      page.source.read(with: io, on: eventLoop).flatMap { (buffer) -> EventLoopFuture<Void> in

        let context = page.leafData
        let content = ContentInputFile(string: String(buffer: buffer)).content
        switch page.source.fileType {
        case .html:
          break
        case .leaf:
          break
        case .md:
          leafRenderer.render(path: page.source.publishType.templateName, context: ["website": website.leafData])
        case .mdLeaf:
          break
        }

        return eventLoop.makeSucceededFuture(())
      }
    }
    return EventLoopFuture<Void>.whenAllComplete(futures, on: eventLoop).flatMap { (results) -> EventLoopFuture<Void> in
      return eventLoop.makeSucceededFuture(())
    }
  }

  private func context(page: Page, website: Website) -> [String: LeafData] {
    return ["page":page.leafData, "website": website.leafData]
  }
}

class InMemoryLeafSource: LeafSource {
  var memory: [String: String] = .init()
  func file(template: String, escape: Bool, on eventLoop: EventLoop) throws -> EventLoopFuture<ByteBuffer> {
    if let string = memory[template] {
      return eventLoop.makeSucceededFuture(ByteBuffer(string: string))
    } else {
      return eventLoop.makeFailedFuture(NotFoundError())
    }
  }

  struct NotFoundError: Error {

  }

  func register(content: String, at path: String) {

  }

  func removeContent(at path: String) {

  }
}
