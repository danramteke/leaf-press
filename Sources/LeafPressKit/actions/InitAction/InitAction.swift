import Foundation
import NIO
import PathKit

public class InitAction {
  let workDir: Path
  public init(workDir: Path) {
    self.workDir = workDir
  }

  public func scaffold(dryRun: Bool) -> Result<[String], Error> {
    return Result {
      if !dryRun {
        try workDir.mkpath()
      }

      let resourcePath = Path(Bundle.module.resourcePath!) + Path("scaffold")
      let children = try resourcePath.recursiveChildren()
      return try children.map { path in
        let relativePath = path.relative(to: resourcePath)



        let targetPath = workDir + relativePath
        if !dryRun {
          if path.isDirectory {
            try targetPath.mkpath()
          } else {
            try path.copy(targetPath)
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
