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
    process.launchPath = "/bin/sh"
    process.arguments = ["-c", script]

    let stdOut = Pipe()
    let stdErr = Pipe()

    process.standardOutput = stdOut
    process.standardError = stdErr

    stdOut.fileHandleForReading.readabilityHandler = Self.filePipeHandler
    stdErr.fileHandleForReading.readabilityHandler = Self.filePipeHandler


    process.launch()
    process.waitUntilExit()
    if process.terminationStatus == 0 {
      return .success(())
    } else {
      return .failure(Error(terminationStatus: process.terminationStatus))
    }
  }

  private static let filePipeHandler: (FileHandle) -> () = { handle in
    do {
      guard let data = try handle.readToEnd() else {
        return
      }

      guard let string = String(data: data, encoding: .utf8) else {
        print("couldn't get utf8 string")
        return
      }

      print(string)
    } catch {
      print("error reading stdout", error)
    }
  }

  public struct Error: Swift.Error, LocalizedError {
    public let terminationStatus: Int32

    public var errorDescription: String? {
      "Non zero exit: \(terminationStatus)"
    }
  }
}
