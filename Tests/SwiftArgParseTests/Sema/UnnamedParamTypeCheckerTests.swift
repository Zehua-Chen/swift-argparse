//
//  UnnamedParamTypeCheckerTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/28/19.
//

import XCTest
@testable import SwiftArgParse

final class UnnamedParamTypeCheckerTests: XCTestCase {

    func testEmpty() {
        let context = ASTContext(
            subcommands: [],
            unnamedParams: [],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .single(type: Int.self),
            .single(type: Int.self)
        ])

        guard case .failure(let error) = checker.check(against: context) else {
            XCTFail()
            return
        }

        guard case .overflow(let index) = error else {
            XCTFail()
            return
        }

        XCTAssertEqual(index, 0)
    }

    func testNonRecurringSuccess() {
        let context = ASTContext(
            subcommands: [""],
            unnamedParams: ["a", "b", "c"],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .single(type: String.self),
            .single(type: String.self),
            .single(type: String.self)
        ])

        if case .failure(let error) = checker.check(against: context) {
            XCTFail(String(describing: error))
        }
    }

    func testSingleRecurringSuccess() {
        let context = ASTContext(
            subcommands: [""],
            unnamedParams: ["a", "b", "c"],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .recurring(type: String.self)
        ])

        if case .failure(let error) = checker.check(against: context) {
            XCTFail(String(describing: error))
        }
    }

    func testSingleRecurringFailure() {
        let context = ASTContext(
            subcommands: [""],
            unnamedParams: ["a", "b", 12],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .recurring(type: String.self)
        ])

        guard case .failure(let error) = checker.check(against: context) else {
            XCTFail()
            return
        }

        guard case .inconsistant(let index, let expected, let found) = error else {
            XCTFail(String(describing: error))
            return
        }

        XCTAssertEqual(index, 2)
        XCTAssert(expected == String.self)
        XCTAssert(found == Int.self)
    }

    func testUnderflow() {
        let context = ASTContext(
            subcommands: [""],
            unnamedParams: [12, 12, 12],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .single(type: Int.self),
            .single(type: Int.self),
        ])

        guard case .failure(let error) = checker.check(against: context) else {
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
            unnamedParams: ["a", "b", 12, 22],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .recurring(type: String.self),
            .recurring(type: Int.self)
        ])

        if case .failure(_) = checker.check(against: context) {
            XCTFail()
        }
    }

    func testCombinedSuccess() {
        let context = ASTContext(
            subcommands: [""],
            unnamedParams: ["a", "b", 12, 12.0, 12.0],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .recurring(type: String.self),
            .single(type: Int.self),
            .recurring(type: Double.self)
        ])

        guard case .success = checker.check(against: context) else {
            XCTFail()
            return
        }
    }

    func testCombinedFailure() {
        let context = ASTContext(
            subcommands: [""],
            unnamedParams: ["a", "b", 12, 12.0, 12.0],
            namedParams: [:])

        let checker = UnnamedParamTypeChecker(paramInfo: [
            .single(type: Int.self),
            .single(type: Int.self),
            .recurring(type: Double.self)
        ])

        guard case .failure(let error) = checker.check(against: context) else {
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
