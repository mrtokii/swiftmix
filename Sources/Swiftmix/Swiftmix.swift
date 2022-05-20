import Foundation


struct SwiftmixError: Error {
    
    let message: String
    
    var errorMessage: String {
        "Error: \(message)"
    }
}


public final class Swiftmix {
    
    private let args: [String]
    private let stdoutPipe: Pipe?
    
    
    public init(stdoutPipe: Pipe? = nil, args: [String] = CommandLine.arguments) {
        self.args = args
        self.stdoutPipe = stdoutPipe
    }
    
    
    public func run() {
        do {
            try _run()
        } catch let e as SwiftmixError {
            print(e.errorMessage)
            exit(1)
        } catch let e {
            print(e.localizedDescription)
            exit(1)
        }
    }
    
    
    private func _run() throws {
        guard args.count > 1 else {
            throw SwiftmixError(message: "There must be at least one argument present")
        }
        
        let filePath = args[1]
        guard let fileUrl = URL(string: filePath) else {
            throw SwiftmixError(message: "\(filePath) is not a valid path")
        }
        
        let lines = try Mixer(mainFileUrl: fileUrl).process()
        try Interpreter(stdoutPipe: stdoutPipe).run(lines, args: args)
    }
}
