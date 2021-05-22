import Foundation
import NIO
import MPath

public class InitAction {
  let workDir: Path
  public init(workDir: Path) {
    self.workDir = workDir
  }

  public func scaffold(dryRun: Bool) -> Result<[String], Error> {
    return Result {
      if !dryRun {
        try workDir.createDirectories()
      }

      let resourcePath = Path(Bundle.module.bundlePath) + Path("scaffold")
      let children = try resourcePath.recursiveChildren()
      return try children.map { path in
        let relativePath = path.relative(to: resourcePath)

        let targetPath = workDir + relativePath
        if !dryRun {
          if path.isDirectory {
            try targetPath.createDirectories()
          } else {
            try path.copy(to: targetPath)
          }
        }

        if path.isDirectory {
          return targetPath.relative(to: Path.current).string + "/"
        } else {
          return targetPath.relative(to: Path.current).string
        }
      }
    }
  }
}
