import Foundation

@discardableResult
func safeShell(_ command: String) throws -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    
    #if os(Linux)
    task.executableURL = URL(fileURLWithPath: "/bin/bash") //<--updated
    #else
    task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
    #endif

    try task.run() //<--updated
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

