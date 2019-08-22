//
//  PathResolverTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 8/22/19.
//

import XCTest
@testable import SwiftArgParse

class PathProcessorTests: XCTestCase {

    let configuration: Configuration = Configuration()

    override func setUp() {
        super.setUp()

        let config = Configuration()
        config.children["2-0"] = Configuration()

        // config starts with level 1, as level 0 is not parsed
        self.configuration.children["1-0"] = config
        self.configuration.children["1-1"] = Configuration()
    }

    func testEmpty() {
        var context = _ASTContext(elements: [])
        _PathProcessor().run(on: &context, with: self.configuration)

        XCTAssertTrue(context.elements.isEmpty)
    }

    func testLevelOne() {
        var context = _ASTContext(elements: [
            .primitive(.init(value: "1-1"))
        ])

        _PathProcessor().run(on: &context, with: self.configuration)

        XCTAssertEqual(context.elements[0]!.asPath().value, "1-1")
    }

    func testLevelTwo() {
        var context = _ASTContext(elements: [
            .primitive(.init(value: "1-0")),
            .primitive(.init(value: "2-0"))
        ])

        _PathProcessor().run(on: &context, with: self.configuration)

        XCTAssertEqual(context.elements[0]!.asPath().value, "1-0")
        XCTAssertEqual(context.elements[1]!.asPath().value, "2-0")
    }

    func testNotMatchingLevelOne() {
        var context = _ASTContext(elements: [
            .primitive(.init(value: "param"))
        ])

        _PathProcessor().run(on: &context, with: self.configuration)

        XCTAssertEqual(context.elements[0]!.asPrimitive().value as! String, "param")
    }

    func testNotMatchingLevelTwo() {
        var context = _ASTContext(elements: [
            .primitive(.init(value: "1-1")),
            .primitive(.init(value: "param"))
        ])

        _PathProcessor().run(on: &context, with: self.configuration)

        XCTAssertEqual(context.elements[0]!.asPath().value, "1-1")
        XCTAssertEqual(context.elements[1]!.asPrimitive().value as! String, "param")
    }
}
