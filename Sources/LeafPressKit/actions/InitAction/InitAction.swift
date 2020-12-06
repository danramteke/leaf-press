import Foundation
import NIO
import PathKit

public class InitAction {
  let workDir: Path
  public init(workDir: Path) {
    self.workDir = workDir
  }

  public func scaffold() -> Result<[String], Error> {
    return .success([])
    // return Result {
    //     Bundle.module.
    // }
  }
}
