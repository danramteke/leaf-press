//
//  File.swift
//  
//
//  Created by Daniel Ramteke on 12/2/20.
//

import Foundation
import PathKit



class FileTree {
  let config: Config



  let postLocations: [FileLocation]
  let pageLocations: [FileLocation]
  let staticFileLocations: [FileLocation]
  init(config: Config) {
    self.config = config


    let lambda = { (path: Path, glob: String) -> [FileLocation] in
      path.glob(glob).compactMap { (childPath) -> FileLocation? in
        FileLocation(path: childPath.absolute(), root: path)
    }

    }
    self.postLocations = lambda(self.config.postsDir, FileType.glob)
    self.pageLocations = lambda(self.config.pagesDir, FileType.glob)
    self.staticFileLocations = lambda(self.config.staticFilesDir, "*")
  }

  func discover() {
    print("pages:", pageLocations.map({ $0.relativePath }))
    print("posts:", postLocations.map({ $0.relativePath }))
    print("statics:", staticFileLocations.map({ $0.relativePath }))
  }


}
