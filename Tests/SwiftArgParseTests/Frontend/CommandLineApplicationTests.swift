//
//  CommandLineApplicationTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 7/30/19.
//

import XCTest
@testable import SwiftArgParse

final class CommandLineApplicationTests: XCTestCase {
    func testTreeConstruction() {
        var app = CommandLineApplication(name: "tools")
        let rootNode = app._rootCommandNode

        try! app.add(path: ["tools", "test"]) { _ in }
        try! app.add(path: ["tools", "package", "generate"]) { _ in }
        try! app.add(path: ["tools", "package"]) { _ in }

        // Test names
        XCTAssertEqual(rootNode.name, "tools")
        XCTAssertEqual(rootNode.children["test"]!.name, "test")
        XCTAssertEqual(rootNode.children["package"]!.name, "package")
        XCTAssertEqual(rootNode.children["package"]!.children["generate"]!.name, "generate")

        // Test commands
        XCTAssert(rootNode.executor == nil)
        XCTAssert(rootNode.children["test"]?.executor != nil)
    }

    func testRunWithoutOptionalParams() {
        var app = CommandLineApplication(name: "tools")
        var counter = 0

        try! app.add(path: ["tools", "sub1"]) { (context) in
            counter += context.optionalParams["-data"] as! Int
        }

        var toolsCommand = try! app.add(path: ["tools"]) { (context) in
            counter += context.optionalParams["--data"] as! Int
        }

        toolsCommand.defaultOptionalParams = ["--data": -100]

        var sub2Command = try! app.add(path: ["tools", "sub2"]) { (context) in
            counter += context.optionalParams["--data"] as! Int
        }

        sub2Command.defaultOptionalParams = ["--data": 100]

        try! app.run(with: ["tools", "sub1", "-data=1"])
        try! app.run(with: ["tools", "--data=10"])
        try! app.run(with: ["tools", "sub2"])

        XCTAssertEqual(counter, 111)
    }
}
