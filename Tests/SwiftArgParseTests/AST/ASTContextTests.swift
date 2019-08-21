//
//  ASTContextTests.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/9/19.
//

import XCTest
@testable import SwiftArgParse

final class ASTContextTests: XCTestCase {
    func testOptions() {
        let context = try! _ASTContext(args: [
            "-a=true",
            "-d=12",
            "--d=-12",
            "-f=fff",
        ])

        let elements = context.elements.compactMap { return $0 }

        // -a=true
        XCTAssertEqual(elements[0].asOption().name, "-a")
        XCTAssertEqual(elements[0].location, [0, 0]...[0, 6])
        XCTAssertEqual(elements[0].asOption().value as! Bool, true)

        // -d=12
        XCTAssertEqual(elements[1].asOption().name, "-d")
        XCTAssertEqual(elements[1].location, [1, 0]...[1, 4])
        XCTAssertEqual(elements[1].asOption().value as! Int, 12)

        // -d=-12
        XCTAssertEqual(elements[2].asOption().name, "--d")
        XCTAssertEqual(elements[2].location, [2, 0]...[2, 6])
        XCTAssertEqual(elements[2].asOption().value as! Int, -12)

        // -f=fff
        XCTAssertEqual(elements[3].asOption().name, "-f")
        XCTAssertEqual(elements[3].location, [3, 0]...[3, 5])
        XCTAssertEqual(elements[3].asOption().value as! String, "fff")
    }

    func testOptionsWithoutValues() {
        let context = try! _ASTContext(args: [
            "-a=true",
            "-b",
        ])

        let elements = context.elements.compactMap { return $0 }

        // -a=true
        XCTAssertEqual(elements[0].asOption().name, "-a")
        XCTAssertEqual(elements[0].location, [0, 0]...[0, 6])
        XCTAssertEqual(elements[0].asOption().value as! Bool, true)

        // -b
        XCTAssertEqual(elements[1].asOption().name, "-b")
        XCTAssertEqual(elements[1].location, [1, 0]...[1, 1])
        XCTAssert(elements[1].asOption().value == nil)
    }

    func testPrimitives() {
        let context = try! _ASTContext(args: [
            "name",
            "12",
            "-12",
            "false",
            "-12.0"
        ])

        let elements = context.elements.compactMap { return $0 }

        // name
        XCTAssertEqual(elements[0].location, [0, 0]...[0, 3])
        XCTAssertEqual(elements[0].asPrimitive().value as! String, "name")

        // 12
        XCTAssertEqual(elements[1].location, [1, 0]...[1, 1])
        XCTAssertEqual(elements[1].asPrimitive().value as! Int, 12)

        // -12
        XCTAssertEqual(elements[2].location, [2, 0]...[2, 2])
        XCTAssertEqual(elements[2].asPrimitive().value as! Int, -12)

        // 12
        XCTAssertEqual(elements[3].location, [3, 0]...[3, 4])
        XCTAssertEqual(elements[3].asPrimitive().value as! Bool, false)

        // -12.0
        XCTAssertEqual(elements[4].location, [4, 0]...[4, 4])
        XCTAssertEqual(elements[4].asPrimitive().value as! Double, -12.0)
    }
}
