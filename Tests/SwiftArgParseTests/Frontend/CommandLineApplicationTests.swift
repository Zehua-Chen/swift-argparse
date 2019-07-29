//
//  CommandLineApplicationTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 7/30/19.
//

import XCTest
@testable import SwiftArgParse

struct FooCommand: Command {
    func run(with context: ASTContext) {
    }
}

final class CommandLineApplicationTests: XCTestCase {
    func testTreeConstruction() {
        var app = CommandLineApplication(name: "tools")

        try! app.add(
            command: FooCommand(),
            path: ["tools", "test"])

        try! app.add(
            command: FooCommand(),
            path: ["tools", "package", "generate"])

        try! app.add(
            command: FooCommand(),
            path: ["tools", "package"])

        let rootNode = app._rootCommandNode

        // Test names
        XCTAssertEqual(rootNode.name, "tools")
        XCTAssertEqual(rootNode.children["test"]!.name, "test")
        XCTAssertEqual(rootNode.children["package"]!.name, "package")
        XCTAssertEqual(rootNode.children["package"]!.children["generate"]!.name, "generate")

        // Test commands
        XCTAssert(rootNode.command == nil)
        XCTAssert(rootNode.children["test"]?.command != nil)
    }
}
