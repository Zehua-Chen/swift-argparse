//
//  File.swift
//  SwiftArgParsePackageTests
//
//  Created by Zehua Chen on 7/23/19.
//

import XCTest
@testable import SwiftArgParse

final class NamedParamCheckerTests: XCTestCase {
    func testTypeCheckingOK() {
        let checker = NamedParamChecker(typeInfo: [
            "-str": String.self,
            "-b": Bool.self
        ])

        let context = try! ASTContext(args: ["-str=a", "-b"], root: _CommandNode(name: ""))
        XCTAssertNoThrow(try checker.check(against: context))
    }

    func testTypeCheckingFail() {
        let checker = NamedParamChecker(typeInfo: [
            "-str": String.self,
            "-b": Int.self
            ])

        let context = try! ASTContext(args: ["-str=a", "-b"], root: _CommandNode(name: ""))
        XCTAssertThrowsError(try checker.check(against: context), "", { (error) in
            guard case NamedParamCheckerError.inconsistant(let name, let expecting, let found) = error else {
                XCTFail()
                return
            }

            XCTAssertEqual(name, "-b")
            XCTAssert(expecting == Int.self)
            XCTAssert(found == Bool.self)
        })


    }

    func testNotPresent() {
        
    }
}
