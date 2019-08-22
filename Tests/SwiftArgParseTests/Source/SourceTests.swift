//
//  SourceTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/9/19.
//

import XCTest
@testable import SwiftArgParse

final class SourceTests: XCTestCase {

    func enumerate(_ blocks: [String]) -> [_Source.Element] {
        var source = _Source(input: blocks[...])
        var output = [_Source.Element]()

        while let element = source.next() {
            output.append(element)
        }

        return output
    }

    func testSingeBlock() {
        let blocks = enumerate(["abc"])
        XCTAssertEqual(blocks, [
            .character("a"),
            .character("b"),
            .character("c"),
            .endBlock
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
            .endBlock
        ])
    }

    func testPosition() {
        var source = _Source(input: ["ab", "c"])

        XCTAssertEqual(source.next(), .character("a"))
        XCTAssertEqual(source.point, .init(block: 0, index: 0))

        XCTAssertEqual(source.next(), .character("b"))
        XCTAssertEqual(source.point, .init(block: 0, index: 1))

        XCTAssertEqual(source.next(), .endBlock)
        XCTAssertEqual(source.point, .init(block: 0, index: 2))

        XCTAssertEqual(source.next(), .character("c"))
        XCTAssertEqual(source.point, .init(block: 1, index: 0))
    }
}
