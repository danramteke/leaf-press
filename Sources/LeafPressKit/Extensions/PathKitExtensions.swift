import PathKit
import Foundation

extension Path {
  public func appending(_ string: String?, default: Path) -> Path {
    if let string = string {
      return self + Path(string)
    } else {
      return self + `default`
    }
  }

  public func relative(to parent: Path) -> Path {
    var meAbs = self.absolute().string
    let parentsAbs = parent.absolute().string

    guard meAbs.starts(with: parentsAbs) else {
      return self
    }

    meAbs.removeSubrange(...parentsAbs.endIndex)

    return Path(meAbs)

  }
}
