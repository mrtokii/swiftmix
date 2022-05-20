import Foundation


class Interpreter {
    
    private let stdoutPipe: Pipe?
    
    
    init(stdoutPipe: Pipe? = nil) {
        self.stdoutPipe = stdoutPipe
    }

    
    func run(_ lines: [String], args: [String]) throws {
        
        // Remove Process launch arguments
        let adjustedLines = ["CommandLine.arguments.removeFirst(2)"] + lines
        let sourceCode = adjustedLines.joined(separator: "\n")
        
        guard let data = sourceCode.data(using: .utf8) else {
            throw SwiftmixError(message: "Could not create data from source code")
        }
        
        let process = Process()
        let stdinPipe = Pipe()
        
        process.launchPath = "/usr/bin/swift"
        process.arguments = ["-"] + args
        process.standardInput = stdinPipe
        if let stdoutPipe = stdoutPipe {
            process.standardOutput = stdoutPipe
        }
        
        try stdinPipe.fileHandleForWriting.write(contentsOf: data)
        stdinPipe.fileHandleForWriting.closeFile()
        
        process.launch()
        process.waitUntilExit()
        
        if process.terminationStatus != 0 {
            throw SwiftmixError(message: "Swift compiler exited with status \(process.terminationStatus)")
        }
    }
}
