//
//  SourcePoint.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/20/19.
//

public struct SourcePoint:
    ExpressibleByArrayLiteral,
    Comparable,
    CustomStringConvertible {

    public typealias ArrayLiteralElement = Int

    public let block: Int
    public let index: Int

    public var description: String {
        return "(block: \(self.block), index: \(self.index)"
    }

    public init(block: Int, index: Int) {
        self.block = block
        self.index = index
    }

    public init(arrayLiteral elements: Int...) {
        self.block = elements[0]
        self.index = elements[1]
    }

    public static func ==(lhs: SourcePoint, rhs: SourcePoint) -> Bool {
        return lhs.block == rhs.block && lhs.index == rhs.index
    }

    public static func <(lhs: SourcePoint, rhs: SourcePoint) -> Bool {
        return lhs.block < rhs.block || lhs.index < rhs.index
    }

    public static func >(lhs: SourcePoint, rhs: SourcePoint) -> Bool {
        return lhs.block > rhs.block || lhs.index > rhs.index
    }
}
