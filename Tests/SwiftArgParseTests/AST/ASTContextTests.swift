//
//  ASTContextTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/9/19.
//

import XCTest
@testable import SwiftArgParse

final class ASTContextTests: XCTestCase {
    func testOptionalParams() {
        let context = try! ASTContext(from: [
            "-a=true",
            "-b",
            "--c=false",
            "-d=12",
            "--d=-12",
            "---e=billy herrington"
        ], root: _CommandNode(name: "test"))

        XCTAssertEqual(context.optionalParams["-a"] as! Bool, true)
        XCTAssertEqual(context.optionalParams["-b"] as! Bool, true)
        XCTAssertEqual(context.optionalParams["--c"] as! Bool, false)
        XCTAssertEqual(context.optionalParams["-d"] as! Int, 12)
        XCTAssertEqual(context.optionalParams["--d"] as! Int, -12)
        XCTAssertEqual(context.optionalParams["---e"] as! String, "billy herrington")
    }

    func testTrailingBooleanOptionalParam() {
        let context = try! ASTContext(from: [
            "-a=true",
            "-b",
        ], root: _CommandNode(name: ""))

        XCTAssertEqual(context.optionalParams["-a"] as! Bool, true)
        XCTAssertEqual(context.optionalParams["-b"] as! Bool, true)
    }

    func testSubcommands() {
        let subcommand1 = _CommandNode(name: "subcommand_1")
        let subcommand2 = subcommand1.add(subcommand: "subcommand_2")
        let _ = subcommand2.add(subcommand: "subcommand_3")

        let context = try! ASTContext(from: [
            "subcommand_1",
            "subcommand_2",
            "subcommand_3",
            "required_param_2",
            "-12"
        ], root: subcommand1)

        XCTAssertTrue(context.subcommands.contains("subcommand_1"))
        XCTAssertTrue(context.subcommands.contains("subcommand_2"))
        XCTAssertTrue(context.subcommands.contains("subcommand_3"))

        XCTAssertTrue(context.requiredParams.contains(where: {
            guard let str = $0 as? String else { return false }
            return str == "required_param_2"
        }))

        XCTAssertTrue(context.requiredParams.contains(where: {
            guard let i = $0 as? Int else { return false }
            return i == -12
        }))
    }
}
