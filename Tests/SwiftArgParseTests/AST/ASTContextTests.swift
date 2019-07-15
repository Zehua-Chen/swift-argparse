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
            "-e=billy herrington"
        ])

        XCTAssertEqual(context.optionalParams["-a"]!, .boolean(true))
        XCTAssertEqual(context.optionalParams["-b"]!, .boolean(true))
        XCTAssertEqual(context.optionalParams["--c"]!, .boolean(false))
        XCTAssertEqual(context.optionalParams["-d"]!, .int(12))
        XCTAssertEqual(context.optionalParams["--d"]!, .int(-12))
        XCTAssertEqual(context.optionalParams["-e"]!, .string("billy herrington"))
    }

    func testSubcommands() {
        let context = try! ASTContext(from: [
            "subcommand_1",
            "subcommand_2",
            "required_param_2",
        ])

        XCTAssertTrue(context.subcommands.contains("subcommand_1"))
        XCTAssertTrue(context.subcommands.contains("subcommand_2"))
        // Required parameters are considered to be subcommands until
        // the semantic stage
        XCTAssertTrue(context.subcommands.contains("required_param_2"))
    }
}
