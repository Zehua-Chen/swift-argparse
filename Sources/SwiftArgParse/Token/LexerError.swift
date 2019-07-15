//
//  ParserError.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/15/19.
//

/// Error thrown for errors in the lexer
public enum LexerError: Error {
    /// Error thrown when there is an expected character
    case unexpected(character: Character)
    /// Error thrown when the string is expected
    case expecting(string: String)
    /// Error thrown the the number fails to parse
    case unableToParseNumber
}
