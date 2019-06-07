//
//  File.swift
//  
//
//  Created by Zehua Chen on 6/7/19.
//

import XCTest
@testable import SwiftArgParse

final class SourceTests: XCTestCase {
    func testRead() {
        var source = _Source(from: ["ab", "c", "def"])
        var output = ""

        while let char = source.next() {
            output.append(char)
        }

        XCTAssertEqual("abcdef", output)
    }

    func testEmpty() {
        var source = _Source(from: [String]())
        var output = ""

        while let char = source.next() {
            output.append(char)
        }

        XCTAssertTrue(output.isEmpty)
    }

    func testSingleBlock() {
        var source = _Source(from: ["abc"])
        var output = ""

        while let char = source.next() {
            output.append(char)
        }

        XCTAssertEqual(output, "abc")
    }
}
