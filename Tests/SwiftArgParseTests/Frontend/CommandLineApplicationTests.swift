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
        let rootNode = app._rootCommandNode

        try! app.add(
            path: ["tools", "test"],
            command: FooCommand())

        try! app.add(
            path: ["tools", "package", "generate"],
            command: FooCommand())

        try! app.add(
            path: ["tools", "package"],
            command: FooCommand())

        // Test names
        XCTAssertEqual(rootNode.name, "tools")
        XCTAssertEqual(rootNode.children["test"]!.name, "test")
        XCTAssertEqual(rootNode.children["package"]!.name, "package")
        XCTAssertEqual(rootNode.children["package"]!.children["generate"]!.name, "generate")

        // Test commands
        XCTAssert(rootNode.command == nil)
        XCTAssert(rootNode.children["test"]?.command != nil)
    }

    func testRunWithoutOptionalParams() {
        var app = CommandLineApplication(name: "tools")
        var counter = 0

        try! app.add(path: ["tools", "sub1"]) { (context) in
            counter += context.optionalParams["-data"] as! Int
        }

        try! app.add(path: ["tools"], defaultOptionalParams: ["--data": -100]) { (context) in
            counter += context.optionalParams["--data"] as! Int
        }

        try! app.add(path: ["tools", "sub2"], defaultOptionalParams: ["--data": 100]) { (context) in
            counter += context.optionalParams["--data"] as! Int
        }

        try! app.run(with: ["tools", "sub1", "-data=1"])
        try! app.run(with: ["tools", "--data=10"])
        try! app.run(with: ["tools", "sub2"])

        XCTAssertEqual(counter, 111)
    }
}
