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
        XCTAssert(SourcePoint(block: 0, index: 0) < SourcePoint(block: 0, index: 1))
        XCTAssert(SourcePoint(block: 0, index: 0) < SourcePoint(block: 1, index: 0))
        XCTAssert(SourcePoint(block: 0, index: 0) < SourcePoint(block: 1, index: 1))

        // > test
        XCTAssert(SourcePoint(block: 0, index: 1) > SourcePoint(block: 0, index: 0))
        XCTAssert(SourcePoint(block: 1, index: 0) > SourcePoint(block: 0, index: 0))
        XCTAssert(SourcePoint(block: 1, index: 1) > SourcePoint(block: 0, index: 0))
    }
}
