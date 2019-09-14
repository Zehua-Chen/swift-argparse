//
//  CommandLineExtensionTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 8/22/19.
//

import XCTest
@testable import SwiftArgParse

class CommandLineExtensionTests: XCTestCase {
    func testExecute() {
        class TestCommand: Command {
            var value = 0
            var name = ""

            func setup(with config: Configuration) {
                config.use(Option(name: "--value", defaultValue: 10))
                config.use(Option(name: "--name", defaultValue: "Peter", alias: "-n"))
            }

            func run(with context: CommandContext) {
                self.value += context.value as! Int
                self.name = context.name as! String
            }
        }

        let test = TestCommand()
        CommandLine.run(test, with: ["test", "-n=Philosophor"])

        XCTAssertEqual(test.name, "Philosophor")
        XCTAssertEqual(test.value, 10)
    }
}
