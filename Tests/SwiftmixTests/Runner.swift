import Foundation
import Swiftmix


func runSwiftmix(_ args: [String]) -> String {
    let pipe = Pipe()
    Swiftmix(stdoutPipe: pipe, args: ["swiftmix"] + args).run()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    return String(data: data, encoding: .utf8)!
}
