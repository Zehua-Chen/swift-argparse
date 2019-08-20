//
//  SourcePointTests.swift
//  SwiftArgParseTests
//
//  Created by Zehua Chen on 8/20/19.
//

import XCTest
@testable import SwiftArgParse

class SourcePointTests: XCTestCase {
    func testCompare() {

        // < test
        XCTAssertLessThan(
            SourcePoint(block: 0, index: 0),
            SourcePoint(block: 0, index: 1))

        XCTAssertLessThan(
            SourcePoint(block: 0, index: 0),
            SourcePoint(block: 1, index: 0))

        XCTAssertLessThan(
            SourcePoint(block: 0, index: 0),
            SourcePoint(block: 1, index: 1))

        // > test
        XCTAssertGreaterThan(
            SourcePoint(block: 0, index: 1),
            SourcePoint(block: 0, index: 0))

        XCTAssertGreaterThan(
            SourcePoint(block: 1, index: 0),
            SourcePoint(block: 0, index: 0))

        XCTAssertGreaterThan(
            SourcePoint(block: 1, index: 1),
            SourcePoint(block: 0, index: 0))
    }
}
