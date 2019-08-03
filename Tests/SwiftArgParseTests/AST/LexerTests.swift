//
//  LexerTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 5/25/19.
//

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
            .endBlock,
            .dash,
            .endBlock,
            .dash,
            .dash
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
            .boolean(false)
        ])

        XCTAssertThrowsError(try tokenize(["tru"]))
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
            .uint(123)
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
            .udecimal(123.23),
            .endBlock,
            .dash,
            .string("negative"),
            .assignment,
            .dash,
            .udecimal(123.23)
        ])
    }

    func testPeek() {
        let input = ["-positive=true"]
        var lexer = _Lexer(using: _Source(using: input[...]))

        XCTAssertEqual(try! lexer.peek(), .dash)
        XCTAssertEqual(try! lexer.next(), .dash)
        XCTAssertEqual(try! lexer.next(), .string("positive"))
        XCTAssertEqual(try! lexer.peek(), .assignment)
        XCTAssertEqual(try! lexer.next(), .assignment)
    }
}
