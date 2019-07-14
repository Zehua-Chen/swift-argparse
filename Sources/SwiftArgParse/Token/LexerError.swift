//
//  ParserError.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/15/19.
//

public enum LexerError: Error {
    case unexpected(character: Character)
    case expecting(string: String)
    case unableToParseNumber
}
