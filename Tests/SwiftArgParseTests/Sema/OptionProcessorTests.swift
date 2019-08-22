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
        config.use(Option(name: "--bool", defaultValue: true))
        config.use(Option(name: "--message", defaultValue: ""))
        config.use(Option(name: "--notmerged", defaultValue: ""))

        _OptionProcessor().merge(&context, with: config)

        XCTAssertEqual(context.elements[0]!.asOption().value as! Bool, true)
        XCTAssertEqual(context.elements[1]!.asPrimitive().value as! String, "something")
        XCTAssertEqual(context.elements[2]!.asOption().value as! String, "something")
        XCTAssertNil(context.elements[3])
        XCTAssertEqual(context.elements[4]!.asOption().value as! String, "something")
        XCTAssertNotNil(context.elements[5])
        XCTAssertEqual(context.elements[6]!.asOption().value as! Bool, true)
    }

    func testAlias() {
        var context = try! _ASTContext(args: [
            "-y=true",
            "--full=false"
        ])

        let config = Configuration()
        config.use(Option(name: "--yes", defaultValue: true, alias: "-y", help: ""))
        config.use(Option(name: "--full", defaultValue: true, alias: nil, help: ""))

        _OptionProcessor().alias(&context, with: config)

        XCTAssertEqual(context.elements[0]!.asOption().name, "--yes")
        XCTAssertEqual(context.elements[1]!.asOption().name, "--full")
    }

    func testCheckOK() {
        let context = try! _ASTContext(args: [
            "--bool=true",
            "--message=hello",
            "--number=12.22",
            "--unregistered=true"
        ])

        let config = Configuration()
        config.use(Option(name: "--bool", defaultValue: true))
        config.use(Option(name: "--message", defaultValue: ""))
        config.use(Option(name: "--number", defaultValue: 0.0))
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
        config.use(Option(name: "--bool", defaultValue: false))
        config.use(Option(name: "--message", defaultValue: ""))
        config.use(Option(name: "--number", defaultValue: 10))

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
