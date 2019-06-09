//
//  File.swift
//  
//
//  Created by Zehua Chen on 6/9/19.
//

import XCTest
@testable import SwiftArgParse

final class SourceTests: XCTestCase {

    func enumerate(_ blocks: ArraySlice<String>) -> [_Source.Letter] {
        var source = _Source(using: blocks)
        var letter = source.next()
        var output = [_Source.Letter]()

        while letter != .endOfFile {
            output.append(letter)
            letter = source.next()
        }

        output.append(letter)

        return output
    }

    func testSingeBlock() {
        let blocks = enumerate(["abc"])
        XCTAssertEqual(blocks, [
            .letter("a"),
            .letter("b"),
            .letter("c"),
            .endOfFile
        ])
    }

    func testMultipleBlocks() {
        let blocks = enumerate(["ab", "cd", "e"])
        XCTAssertEqual(blocks, [
            .letter("a"),
            .letter("b"),
            .endOfBlock,
            .letter("c"),
            .letter("d"),
            .endOfBlock,
            .letter("e"),
            .endOfFile
        ])
    }
}
