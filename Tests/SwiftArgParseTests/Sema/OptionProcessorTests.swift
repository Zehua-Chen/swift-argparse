//
//  OptionProcessorTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 8/22/19.
//

import XCTest
@testable import SwiftArgParse


class OptionProcessorTests: XCTestCase {
    func testMerging() {
        var context = try! _ASTContext(args: [
            "--bool",
            "something",
            "--message",
            "something",
            "--notmerged=something",
            "something",
            "--trailing"
        ])

        let config = Configuration()
        config.use(Option(name: "--bool", type: Bool.self))
        config.use(Option(name: "--message", type: String.self))
        config.use(Option(name: "--notmerged", type: String.self))

        _OptionProcessor().merge(&context, with: config)

        XCTAssertEqual(context.elements[0]!.asOption().value as! Bool, true)
        XCTAssertEqual(context.elements[1]!.asPrimitive().value as! String, "something")
        XCTAssertEqual(context.elements[2]!.asOption().value as! String, "something")
        XCTAssertNil(context.elements[3])
        XCTAssertEqual(context.elements[4]!.asOption().value as! String, "something")
        XCTAssertNotNil(context.elements[5])
        XCTAssertEqual(context.elements[6]!.asOption().value as! Bool, true)
    }

    func testCheckOK() {
        let context = try! _ASTContext(args: [
            "--bool=true",
            "--message=hello",
            "--number=12.22",
            "--unregistered=true"
        ])

        let config = Configuration()
        config.use(Option(name: "--bool", type: Bool.self))
        config.use(Option(name: "--message", type: String.self))
        config.use(Option(name: "--number", type: Double.self))
        config.allowsUnregisteredOptions = true

        XCTAssertNoThrow(try _OptionProcessor().check(context, with: config))
    }

    func testCheckFail() {
        let context = try! _ASTContext(args: [
            "--bool=true",
            "--message=12.2",
            "--number=12.22",
            "--unregistered=true"
        ])

        let config = Configuration()
        config.use(Option(name: "--bool", type: Bool.self))
        config.use(Option(name: "--message", type: String.self))
        config.use(Option(name: "--number", type: Double.self))

        XCTAssertThrowsError(try _OptionProcessor().check(context, with: config), "", { error in
            if case OptionError.typeMismatch(let name, let expecting, let found, _) = error {
                XCTAssertEqual(name, "--message")
                XCTAssert(expecting == String.self)
                XCTAssert(found == Double.self)

                return
            }

            XCTFail()
        })
    }
}
