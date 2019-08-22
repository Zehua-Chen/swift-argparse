//
//  CommandLineApplicationTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 7/30/19.
//

import XCTest
@testable import SwiftArgParse

extension Command {
    func run(with context: CommandContext) { }
}

final class ConfigurationTests: XCTestCase {
    func testTreeConstruction() {

        struct LevelB: Command {
            func setup(with config: Configuration) {
            }
        }

        struct LevelA: Command {
            func setup(with config: Configuration) {
                config.use(LevelB(), for: "level-b0")
                config.use(LevelB(), for: "level-b1")
            }
        }

        struct Root: Command {
            func setup(with config: Configuration) {
                config.use(LevelA(), for: "level-a0")
                config.use(LevelA(), for: "level-a1")
            }
        }

        let config = Configuration()
        let root = Root()
        root.setup(with: config)

        // level-a0
        XCTAssertNotNil(config.children["level-a0"])
        XCTAssertNotNil(config.children["level-a0"]!.children["level-b0"])
        XCTAssertNotNil(config.children["level-a0"]!.children["level-b1"])

        XCTAssertNotNil(config.children["level-a1"])
        XCTAssertNotNil(config.children["level-a1"]!.children["level-b0"])
        XCTAssertNotNil(config.children["level-a1"]!.children["level-b1"])
    }

    func testPathTrace() {

    }
}
