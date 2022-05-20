import XCTest
import Swiftmix


final class SwiftmixTests: XCTestCase {
    
    func testSimpleImport() throws {
        XCTAssertEqual(
            runSwiftmix([res("s1.swift")]),
            "Say: Hello\n"
        )
    }
    
    
    func testImportItself() throws {
        XCTAssertEqual(
            runSwiftmix([res("s2.swift")]),
            "Ping\n"
        )
    }
    
    
    func testImportFromSubdir() throws {
        XCTAssertEqual(
            runSwiftmix([res("s3.swift")]),
            "Meow\n"
        )
    }
    
    
    func testPassingArguments() throws {
        XCTAssertEqual(
            runSwiftmix([res("s4.swift"), "Kitty"]),
            "Say: Hello Kitty\n"
        )
    }
}
