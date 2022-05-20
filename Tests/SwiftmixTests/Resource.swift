import Foundation


func res(_ name: String) -> String {
    resources.appendingPathComponent(name, isDirectory: false).path
}


fileprivate let resources: URL = {
    
    func packageRoot(of file: String) -> URL? {
        func isPackageRoot(_ url: URL) -> Bool {
            let filename = url.appendingPathComponent("Package.swift", isDirectory: false)
            return FileManager.default.fileExists(atPath: filename.path)
        }

        var url = URL(fileURLWithPath: file, isDirectory: false)
        repeat {
            url = url.deletingLastPathComponent()
            if url.pathComponents.count <= 1 {
                return nil
            }
        } while !isPackageRoot(url)
        return url
    }

    guard let root = packageRoot(of: #file) else {
        fatalError("\(#file) must be contained in a Swift Package Manager project.")
    }
    
    let fileComponents = URL(fileURLWithPath: #file, isDirectory: false).pathComponents
    let rootComponenets = root.pathComponents.dropFirst()
    let trailingComponents = Array(fileComponents.dropFirst(rootComponenets.count + 1))
    let resourceComponents = rootComponenets + trailingComponents[0...1] + ["Resources"]
    
    return URL(fileURLWithPath: "/" + resourceComponents.joined(separator: "/"), isDirectory: true)
}()
