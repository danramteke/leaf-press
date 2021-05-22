import Foundation

public struct ScriptAction {
  public func start(script: String, workingDirectory: String?) -> Result<Void, Swift.Error> {

    var priorDir: String? = nil
    if let directory = workingDirectory {
      priorDir = FileManager.default.currentDirectoryPath
      FileManager.default.changeCurrentDirectoryPath(directory)
    }
    defer {
      if let priorDir = priorDir {
        FileManager.default.changeCurrentDirectoryPath(priorDir)
      }
    }


    let process = Process()
    process.executableURL = URL(string: "file:///bin/sh")!
    process.arguments = ["-c", script]

    let stdOut = Pipe()
    let stdErr = Pipe()

    process.standardOutput = stdOut
    process.standardError = stdErr

    do {
      try process.run()
    } catch {
      return .failure(error)
    }
    process.waitUntilExit()
    if process.terminationStatus == 0 {
      return .success(())
    } else {
      return .failure(NonZeroTerminationError(terminationStatus: process.terminationStatus))
    }
  }

  public struct NonZeroTerminationError: Swift.Error, LocalizedError {
    public let terminationStatus: Int32

    public var errorDescription: String? {
      "Non zero exit: \(terminationStatus)"
    }
  }
}
