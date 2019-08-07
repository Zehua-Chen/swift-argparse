//
//  ASTContextTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/9/19.
//

import XCTest
@testable import SwiftArgParse

final class ASTContextTests: XCTestCase {
    func testNamedParams() {
        let context = try! ASTContext(args: [
            "-a=true",
            "--c",
            "false",
            "-d=12",
            "--d=-12",
            "---e=billy herrington",
            "-f",
            "fff"
        ], root: _CommandNode(name: "test"))

        XCTAssertEqual(context.namedParams["-a"] as! Bool, true)
        XCTAssertEqual(context.namedParams["--c"] as! Bool, false)
        XCTAssertEqual(context.namedParams["-d"] as! Int, 12)
        XCTAssertEqual(context.namedParams["--d"] as! Int, -12)
        XCTAssertEqual(context.namedParams["---e"] as! String, "billy herrington")
        XCTAssertEqual(context.namedParams["-f"] as! String, "fff")
    }

    func testTrailingBooleanNamedParam() {
        let context = try! ASTContext(args: [
            "-a=true",
            "-b",
        ], root: _CommandNode(name: ""))

        XCTAssertEqual(context.namedParams["-a"] as! Bool, true)
        XCTAssertEqual(context.namedParams["-b"] as! Bool, true)
    }

    func testSubcommands() {
        let subcommand1 = _CommandNode(name: "subcommand_1")
        let subcommand2 = subcommand1.addSubcommand("subcommand_2")
        let _ = subcommand2.addSubcommand("subcommand_3")

        let context = try! ASTContext(args: [
            "subcommand_1",
            "subcommand_2",
            "subcommand_3",
            "unnamed_param_2",
            "-12"
        ], root: subcommand1)

        XCTAssertTrue(context.subcommands.contains("subcommand_1"))
        XCTAssertTrue(context.subcommands.contains("subcommand_2"))
        XCTAssertTrue(context.subcommands.contains("subcommand_3"))

        XCTAssertTrue(context.unnamedParams.contains(where: {
            guard let str = $0 as? String else { return false }
            return str == "unnamed_param_2"
        }))

        XCTAssertTrue(context.unnamedParams.contains(where: {
            guard let i = $0 as? Int else { return false }
            return i == -12
        }))
    }
}
