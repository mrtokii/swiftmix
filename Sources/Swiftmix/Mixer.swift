import Foundation


class Mixer {
    
    private let mainFileUrl: URL

    
    private var fileList: Set<URL>

    
    init(mainFileUrl: URL) {
        self.mainFileUrl = mainFileUrl
        self.fileList = []
    }
    
    
    func process() throws -> [String] {
        guard isFile(mainFileUrl) else {
            throw SwiftmixError(message: "\(mainFileUrl) is not a valid file")
        }
        
        return try processFile(mainFileUrl)
    }
    
    
    private func isFile(_ url: URL) -> Bool {
        let fullPath = url.path
        var isDir: ObjCBool = false
        
        if FileManager.default.fileExists(atPath: fullPath, isDirectory:&isDir) {
            return !isDir.boolValue
        } else {
            return false
        }
    }
    
    
    private func processFile(_ url: URL) throws -> [String] {
        
        guard !fileList.contains(url) else {
            return []
        }
        fileList.insert(url)
        
        let contents = try String(contentsOfFile: url.path)
        let lines = contents
            .split(omittingEmptySubsequences: false, whereSeparator: \.isNewline)
            .map { String($0) }
        let currentSearchUrl = url.deletingLastPathComponent()
        
        var outputLines = [String]()
        var removedHashbang = false
        
        for line in lines {
            if !removedHashbang, line.starts(with: "#!") {
                removedHashbang = true
                continue
            }
            
            if let dependencyFileUrl = try findImportUrl(on: line, currentSearchUrl: currentSearchUrl) {
                outputLines += try processFile(dependencyFileUrl)
            } else {
                outputLines.append(line)
            }
        }
        
        return outputLines
    }
    
    
    private func findImportUrl(on line: String, currentSearchUrl: URL) throws -> URL? {
        
        // Avoid slow regex checking
        guard line.starts(with: "import") else {
            return nil
        }
        
        guard let regex = try? NSRegularExpression(pattern: "import\\s*(\\S*)") else {
            throw SwiftmixError(message: "Could not initialize regex")
        }
        
        let searchRange = NSRange(location: 0, length: line.count)
        
        guard
            let match = regex.firstMatch(in: line, range: searchRange),
            match.numberOfRanges == 2,
            let fileRange = Range(match.range(at: 1), in: line)
        else {
            return nil
        }
        
        let filePath = String(line[fileRange])
        let fileUrl = currentSearchUrl.appendingPathComponent(filePath)
        
        guard isFile(fileUrl) else {
            return nil
        }
        
        return fileUrl
    }
}
