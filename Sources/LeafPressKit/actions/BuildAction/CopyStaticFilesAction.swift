import Foundation
import PathKit

public struct CopyStaticFilesAction {
  let source: String
  let target: String
  init(source: Path, target: Path) {
    let absoluteSource = source.absolute().string
    if absoluteSource.hasSuffix("/") {
      self.source = absoluteSource
    } else {
      self.source = absoluteSource + "/"
    }

    self.target = target.absolute().string
  }

  public func start() -> Result<Void, Swift.Error> {
    let process = Process()
    process.launchPath = "/usr/bin/env"
    process.arguments = ["rsync", "-aq", source, target]

//    let stdOut = Pipe()
    let stdErr = Pipe()

//    process.standardOutput = stdOut
    process.standardError = stdErr
    process.launch()
    process.waitUntilExit()

//    let stdOutData = stdOut.fileHandleForReading.readDataToEndOfFile()
    let stdErrData = stdErr.fileHandleForReading.readDataToEndOfFile()


    if process.terminationStatus == 0 {
      return .success(())
    } else {
      return .failure(Error(terminationStatus: process.terminationStatus, stdErrData: stdErrData))
    }
  }

  public struct Error: Swift.Error, LocalizedError {
    public let terminationStatus: Int32
    let stdErrData: Data

    public var errorDescription: String? {
      "\(terminationStatus): " + (String(data: stdErrData, encoding: .utf8) ?? "")
    }
  }
}

