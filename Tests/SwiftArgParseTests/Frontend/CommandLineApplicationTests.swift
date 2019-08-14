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

        app.addPath(["tools", "test"]) { _ in }
        app.addPath(["tools", "package", "generate"]) { _ in }
        app.addPath(["tools", "package"]) { _ in }

        // Test names
        XCTAssertEqual(rootNode.name, "tools")
        XCTAssertEqual(rootNode.children["test"]!.name, "test")
        XCTAssertEqual(rootNode.children["package"]!.name, "package")
        XCTAssertEqual(rootNode.children["package"]!.children["generate"]!.name, "generate")

        // Test commands
        let testNode = rootNode.children["test"] as! _ExecutableCommandNode

        XCTAssertNotNil(testNode.executor)
    }

    func testRunWithoutNamedParams() {
        var app = CommandLineApplication(name: "tools")
        var counter = 0

        app.addPath(["tools", "sub1"]) { (context) in
            counter += context.namedParams["-data"] as! Int
        }

        let tools = app.addPath(["tools"]) { (context) in
            counter += context.namedParams["--data"] as! Int
        }

        tools.registerNamedParam("--data", defaultValue: -100)

        let sub2 = app.addPath(["tools", "sub2"]) { (context) in
            counter += context.namedParams["--data"] as! Int
        }

        sub2.registerNamedParam("--data", defaultValue: 100)

        try! app.run(with: ["tools", "sub1", "-data=1"])
        try! app.run(with: ["tools", "--data=10"])
        try! app.run(with: ["tools", "sub2"])

        XCTAssertEqual(counter, 111)
    }

    func testPostProcessingStage() {
        var app = CommandLineApplication(name: "tools")

        let path = app.addPath(["tools", "test"])
        path.registerNamedParam("--str", type: String.self)
        path.registerNamedParam("--bool", type: String.self)

        var hasError = false

        do {
            try app.run(with: ["tools", "test", "--str=abc", "--bool=12"])
        } catch {
            hasError = true
        }

        XCTAssert(hasError)
    }
}
