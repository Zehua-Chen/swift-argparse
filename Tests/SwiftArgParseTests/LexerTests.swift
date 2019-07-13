import XCTest
@testable import SwiftArgParse

final class LexerTests: XCTestCase {

    func tokenize(_ data: [String]) throws -> [_Token] {
        var lexer = _Lexer(using: _Source(using: data[0...]))
        var output = [_Token]()

        while let token = try lexer.next() {
            output.append(token)
        }

        return output
    }

    func testNonContextuals() {
        let tokens = try! tokenize(["=", "-", "--"])
        XCTAssertEqual(tokens, [
            .assignment,
            .dash,
            .dash,
            .dash
        ])
    }

    func testString() {
        let tokens = try! tokenize(["compile", "-name=billy herrington"])
        XCTAssertEqual(tokens, [
            .string("compile"),
            .dash,
            .string("name"),
            .assignment,
            .string("billy herrington"),
        ])
    }

    func testBoolean() {
        let tokens = try! tokenize([
            "-right=true",
            "-right=false",
            "true=false"
        ])

        XCTAssertEqual(tokens, [
            .dash,
            .string("right"),
            .assignment,
            .boolean(true),
            .dash,
            .string("right"),
            .assignment,
            .boolean(false),
            .boolean(true),
            .assignment,
            .boolean(false)
        ])

        XCTAssertThrowsError(try tokenize(["tru"]))
    }
}
