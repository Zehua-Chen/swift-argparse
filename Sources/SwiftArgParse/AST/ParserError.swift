//
//  ParserError.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

/// Error thrown during parsing (AST composition)
public enum ParserError: Error {
    /// Thrown when a block separator is expected
    case expectingBlockSeparator
    /// Thrown when a string
    case expectingString
    /// Thrown when a string or a dash is expected
    case expectingStringOrDash
    /// Thrown when a value (string, boolean, int, decimal) is expected
    case expectingValue
    /// Thrown when an assignment or a block separator is expected
    case expectingAssignmentOrBlockSeparator
    case unexpectedFinishing
    case expectingStringOrNumber
}
