//
//  LexerTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 5/25/19.
//

import XCTest
@testable import SwiftArgParse

final class LexerTests: XCTestCase {

    func tokenize(_ data: [String]) throws -> [Token.Value] {
        var lexer = _Lexer(source: _Source(input: data))
        var output = [Token.Value]()

        while let token = try lexer.next() {
            output.append(token.value)
        }

        return output
    }

    func testNonContextuals() {
        let tokens = try! tokenize(["=", "-", "--"])
        XCTAssertEqual(tokens, [
            .assignment,
            .endBlock,
            .dash,
            .endBlock,
            .dash,
            .dash,
            .endBlock
        ])
    }

    func testString() {
        let tokens = try! tokenize(["compile", "-name=billy herrington"])
        XCTAssertEqual(tokens, [
            .string("compile"),
            .endBlock,
            .dash,
            .string("name"),
            .assignment,
            .string("billy herrington"),
            .endBlock
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
            .endBlock,
            .dash,
            .string("right"),
            .assignment,
            .boolean(false),
            .endBlock,
            .boolean(true),
            .assignment,
            .boolean(false),
            .endBlock
        ])
    }

    func testInt() {
        let tokens = try! tokenize([
            "-positive=123",
            "-negative=-123"
        ])

        XCTAssertEqual(tokens, [
            .dash,
            .string("positive"),
            .assignment,
            .uint(123),
            .endBlock,
            .dash,
            .string("negative"),
            .assignment,
            .dash,
            .uint(123),
            .endBlock
        ])
    }

    func testDecimal() {
        let tokens = try! tokenize([
            "-positive=123.23",
            "-negative=-123.23"
        ])

        XCTAssertEqual(tokens, [
            .dash,
            .string("positive"),
            .assignment,
            .udouble(123.23),
            .endBlock,
            .dash,
            .string("negative"),
            .assignment,
            .dash,
            .udouble(123.23),
            .endBlock
        ])
    }

    func testPeek() {
        let args = ["-positive=true"]
        var lexer = _Lexer(source: _Source(input: args))

        XCTAssertEqual(try! lexer.peek()!.value, .dash)
        XCTAssertEqual(try! lexer.peek(offset: 1)!.value, .string("positive"))

        XCTAssertEqual(try! lexer.next()!.value, .dash)
        XCTAssertEqual(try! lexer.next()!.value, .string("positive"))

        XCTAssertEqual(try! lexer.peek()!.value, .assignment)
        XCTAssertEqual(try! lexer.next()!.value, .assignment)
    }

    func testPosition() {
        let args = ["-truth=true", "something", "12.33"]
        var lexer = _Lexer(source: _Source(input: args))
        // -
        XCTAssertEqual(try! lexer.next()!.location, [0, 0]...[0, 0])
        // name
        XCTAssertEqual(try! lexer.next()!.location, [0, 1]...[0, 5])
        // =
        XCTAssertEqual(try! lexer.next()!.location, [0, 6]...[0, 6])
        // true
        XCTAssertEqual(try! lexer.next()!.location, [0, 7]...[0, 10])
        // end block
        XCTAssertEqual(try! lexer.next()!.location, [0, 11]...[0, 11])

        // something
        XCTAssertEqual(try! lexer.next()!.location, [1, 0]...[1, 8])
        // end block
        XCTAssertEqual(try! lexer.next()!.location, [1, 9]...[1, 9])

        // 12.33
        XCTAssertEqual(try! lexer.next()!.location, [2, 0]...[2, 4])
        // end block
        XCTAssertEqual(try! lexer.next()!.location, [2, 5]...[2, 5])
    }
}
