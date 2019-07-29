//
//  RequiredParamTypeCheckerTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/28/19.
//

import XCTest
@testable import SwiftArgParse

final class RequiredParamTypeCheckerTests: XCTestCase {
    func testSingleRecurringSuccess() {
        let context = ASTContext(
            subcommands: [""],
            requiredParams: ["a", "b", "c"],
            optionalParams: [:],
            command: Command(name: ""))

        let checker = RequiredParamTypeChecker(typeInfo: [
            .recurrsing(type: String.self)
        ])

        if case .failure(_) = checker.check(context: context) {
            XCTFail()
        }
    }

    func testSingleRecurringFailure() {
        let context = ASTContext(
            subcommands: [""],
            requiredParams: ["a", "b", 12],
            optionalParams: [:],
            command: Command(name: ""))

        let checker = RequiredParamTypeChecker(typeInfo: [
            .recurrsing(type: String.self)
        ])

        guard case .failure(let error) = checker.check(context: context) else {
            XCTFail()
            return
        }

        guard case .inconsistant(let index, let expected, let found) = error else {
            XCTFail()
            return
        }

        XCTAssertEqual(index, 2)
        XCTAssert(expected == String.self)
        XCTAssert(found == Int.self)
    }

    func testUnderflow() {
        let context = ASTContext(
            subcommands: [""],
            requiredParams: [12, 12, 12],
            optionalParams: [:],
            command: Command(name: ""))

        let checker = RequiredParamTypeChecker(typeInfo: [
            .single(type: Int.self),
            .single(type: Int.self),
        ])

        guard case .failure(let error) = checker.check(context: context) else {
            XCTFail()
            return
        }

        guard case .overflow(let index) = error else {
            XCTFail()
            return
        }

        XCTAssertEqual(index, 2)
    }

    func testMultipleRecurrsingSuccess() {
        let context = ASTContext(
            subcommands: [""],
            requiredParams: ["a", "b", 12, 22],
            optionalParams: [:],
            command: Command(name: ""))

        let checker = RequiredParamTypeChecker(typeInfo: [
            .recurrsing(type: String.self),
            .recurrsing(type: Int.self)
        ])

        if case .failure(_) = checker.check(context: context) {
            XCTFail()
        }
    }

    func testCombinedSuccess() {
        let context = ASTContext(
            subcommands: [""],
            requiredParams: ["a", "b", 12, 12.0, 12.0],
            optionalParams: [:],
            command: Command(name: ""))

        let checker = RequiredParamTypeChecker(typeInfo: [
            .recurrsing(type: String.self),
            .single(type: Int.self),
            .recurrsing(type: Double.self)
        ])

        guard case .success = checker.check(context: context) else {
            XCTFail()
            return
        }
    }

    func testCombinedFailure() {
        let context = ASTContext(
            subcommands: [""],
            requiredParams: ["a", "b", 12, 12.0, 12.0],
            optionalParams: [:],
            command: Command(name: ""))

        let checker = RequiredParamTypeChecker(typeInfo: [
            .single(type: Int.self),
            .single(type: Int.self),
            .recurrsing(type: Double.self)
        ])

        guard case .failure(let error) = checker.check(context: context) else {
            XCTFail()
            return
        }

        guard case .inconsistant(let index, let expected, let found) = error else {
            XCTFail()
            return
        }

        XCTAssertEqual(index, 0)
        XCTAssert(expected == Int.self)
        XCTAssert(found == String.self)
    }

}
