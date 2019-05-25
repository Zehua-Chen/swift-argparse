import XCTest
@testable import SwiftArgParse

final class SwiftArgParseTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftArgParse().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
