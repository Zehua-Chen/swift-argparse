//
//  SourceLocation.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/20/19.
//

public typealias SourceLocation = ClosedRange<SourcePoint>

public extension SourceLocation {
    func joined(with other: SourceLocation) -> SourceLocation {
        return self.lowerBound...other.upperBound
    }
}
