//
//  ParameterCheckerTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 8/22/19.
//

import XCTest
@testable import SwiftArgParse

class ParameterCheckerTests: XCTestCase {
    func testNonRepeeatingOK() {
        let context = try! _ASTContext(args: [
            "string",
            "12",
            "12.0",
            "true",
        ])

        let config = Configuration()

        config.use(Parameter(type: String.self))
        config.use(Parameter(type: Int.self))
        config.use(Parameter(type: Double.self))
        config.use(Parameter(type: Bool.self))

        XCTAssertNoThrow(try _ParameterChecker().run(on: context, with: config))
    }

    func testNonRepeeatingFail() {
        let context = try! _ASTContext(args: [
            "string",
            "12",
            "12.0",
            "true", // error
        ])

        let config = Configuration()

        config.use(Parameter(type: String.self))
        config.use(Parameter(type: Int.self))
        config.use(Parameter(type: Double.self))
        config.use(Parameter(type: String.self))

        XCTAssertThrowsError(try _ParameterChecker().run(on: context, with: config), "", { error in
            if case ParameterError.typeMismatch(let index, let expecting, let found, _) = error {
                XCTAssertEqual(index, 3)
                XCTAssert(expecting == String.self)
                XCTAssert(found == Bool.self)

                return
            }

            XCTFail()
        })
    }

    func testRepeatingOK() {
        let context = try! _ASTContext(args: [
            "a",
            "1",
            "2",
            "3",
            "true"
        ])

        let config = Configuration()

        config.use(Parameter(type: String.self))
        config.use(Parameter(type: Int.self, isRepeating: true))
        config.use(Parameter(type: Bool.self))

        XCTAssertNoThrow(try _ParameterChecker().run(on: context, with: config))
    }

    func testRepeatingFail() {
        let context = try! _ASTContext(args: [
            "a",
            "1",
            "2",
            "wierd", // error
            "true"
        ])

        let config = Configuration()

        config.use(Parameter(type: String.self))
        config.use(Parameter(type: Int.self, isRepeating: true))
        config.use(Parameter(type: Bool.self))

        XCTAssertThrowsError(try _ParameterChecker().run(on: context, with: config), "", { error in
            if case ParameterError.typeMismatch(let index, let expecting, let found, _) = error {
                XCTAssertEqual(index, 3)
                XCTAssert(expecting == Bool.self)
                XCTAssert(found == String.self)

                return
            }

            XCTFail()
        })
    }
}
