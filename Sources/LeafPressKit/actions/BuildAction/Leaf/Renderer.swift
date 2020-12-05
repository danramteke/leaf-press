import Foundation
import NIO
import LeafKit
import PathKit
import Down

class Renderer {
  let inMemory = InMemoryLeafSource()

  let config: Config
  init(config: Config) {
    self.config = config
  }

  func render(website: Website, in threadPool: NIOThreadPool, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<Void> {
    let io = NonBlockingFileIO(threadPool: threadPool)

    let templatesDir = config.templatesDir.absolute().string
    let leafConfig = LeafConfiguration(rootDirectory: templatesDir)
    let sources = LeafSources.singleSource(NIOLeafFiles(fileio: io, sandboxDirectory: templatesDir, viewDirectory: templatesDir))
    try! sources.register(source: "in-memory", using: inMemory, searchable: true)
    let leafRenderer = LeafRenderer(
      configuration: leafConfig,
      sources: sources,
      eventLoop: eventLoopGroup.next()
    )

    let pageFutures: [EventLoopFuture<Void>] = self.render(renderables: website.pages, leafRenderer: leafRenderer, website: website, with: io, on: eventLoopGroup)
    let postFutures: [EventLoopFuture<Void>] = self.render(renderables: website.posts, leafRenderer: leafRenderer, website: website, with: io, on: eventLoopGroup)


    return EventLoopFuture<Void>.whenAllComplete(pageFutures + postFutures, on: eventLoopGroup.next()).flatMap { (results) -> EventLoopFuture<Void> in
      return eventLoopGroup.next().makeSucceededFuture(())
    }
  }

  private func render(renderables: [Renderable], leafRenderer: LeafRenderer, website: Website, with io: NonBlockingFileIO, on eventLoopGroup: EventLoopGroup) -> [EventLoopFuture<Void>] {
    return renderables.map { (r) -> EventLoopFuture<Void> in
      return self.render(renderable: r, leafRenderer: leafRenderer, website: website, with: io, on: eventLoopGroup)
    }
  }

  private func render(renderable: Renderable, leafRenderer: LeafRenderer, website: Website, with io: NonBlockingFileIO, on eventLoopGroup: EventLoopGroup) -> EventLoopFuture<Void> {
    renderable.source.read(with: io, on: eventLoopGroup.next()).flatMap { (buffer) -> EventLoopFuture<Void> in
      let inputFile = ContentInputFile(string: String(buffer: buffer))
      let content = inputFile.content


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
            return renderable.target.write(buffer: renderedBuffer, with: io, on: eventLoopGroup.next())
          }

      case .leaf:
        let context = [
          "current": renderable.leafData,
          "website": website.leafData,
        ]

        self.inMemory.register(content: content, at: inputFile.sha256)
        return leafRenderer
          .render(path: inputFile.sha256, context: context)
          .flatMap { (renderedBuffer) -> EventLoopFuture<Void> in
            self.inMemory.removeContent(at: inputFile.sha256)
            return renderable.target.write(buffer: renderedBuffer, with: io, on: eventLoopGroup.next())
          }


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
              return renderable.target.write(buffer: renderedBuffer, with: io, on: eventLoopGroup.next())
            }
        } catch {
          return eventLoopGroup.next().makeFailedFuture(error)
        }
      }
    }
  }
}