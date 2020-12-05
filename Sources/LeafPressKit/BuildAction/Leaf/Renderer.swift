import Foundation
import NIO
import LeafKit
import PathKit
import Down

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

    let pageFutures: [EventLoopFuture<Void>] = self.render(renderables: website.pages, leafRenderer: leafRenderer, website: website, with: io, on: eventLoop)
    let postFutures: [EventLoopFuture<Void>] = self.render(renderables: website.posts, leafRenderer: leafRenderer, website: website, with: io, on: eventLoop)


    return EventLoopFuture<Void>.whenAllComplete(pageFutures + postFutures, on: eventLoop).flatMap { (results) -> EventLoopFuture<Void> in
      return eventLoop.makeSucceededFuture(())
    }
  }

  private func render(renderables: [Renderable], leafRenderer: LeafRenderer, website: Website, with io: NonBlockingFileIO, on eventLoop: EventLoop) -> [EventLoopFuture<Void>] {
    return renderables.map { (r) -> EventLoopFuture<Void> in
      return self.render(renderable: r, leafRenderer: leafRenderer, website: website, with: io, on: eventLoop)
    }
  }

  private func render(renderable: Renderable, leafRenderer: LeafRenderer, website: Website, with io: NonBlockingFileIO, on eventLoop: EventLoop) -> EventLoopFuture<Void> {
    renderable.source.read(with: io, on: eventLoop).flatMap { (buffer) -> EventLoopFuture<Void> in
      let content = ContentInputFile(string: String(buffer: buffer)).content


      switch renderable.source.fileType {
      case .html:
        let context = [
          "current": renderable.leafData,
          "website": website.leafData,
          "content": content.leafData
        ]
        return leafRenderer
          .render(path: renderable.template, context: context)
          .flatMap { (renderedBuffer) -> EventLoopFuture<Void> in
            return renderable.target.write(buffer: renderedBuffer, with: io, on: eventLoop)
          }

      case .leaf:
        return eventLoop.makeSucceededFuture(())

      case .md:
        do {
          let downContent = try Down(markdownString: content).toHTML(.unsafe)
          let context = [
            "current": renderable.leafData,
            "website": website.leafData,
            "content": downContent.leafData
          ]
          return leafRenderer
            .render(path: renderable.template, context: context)
            .flatMap { (renderedBuffer) -> EventLoopFuture<Void> in
              return renderable.target.write(buffer: renderedBuffer, with: io, on: eventLoop)
            }
        } catch {
          return eventLoop.makeFailedFuture(error)
        }

      case .mdLeaf:
        return eventLoop.makeSucceededFuture(())
      }
    }
  }
}
