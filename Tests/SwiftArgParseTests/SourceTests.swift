//
//  SourceTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/9/19.
//

import XCTest
@testable import SwiftArgParse

final class SourceTests: XCTestCase {

    func enumerate(_ blocks: ArraySlice<String>) -> [_Source.Item] {
        var source = _Source(using: blocks)
        var output = [_Source.Item]()

        while let letter = source.next() {
            output.append(letter)
        }

        return output
    }

    func testSingeBlock() {
        let blocks = enumerate(["abc"])
        XCTAssertEqual(blocks, [
            .character("a"),
            .character("b"),
            .character("c"),
        ])
    }

    func testMultipleBlocks() {
        let blocks = enumerate(["ab", "cd", "e"])
        XCTAssertEqual(blocks, [
            .character("a"),
            .character("b"),
            .endBlock,
            .character("c"),
            .character("d"),
            .endBlock,
            .character("e"),
        ])
    }
}
