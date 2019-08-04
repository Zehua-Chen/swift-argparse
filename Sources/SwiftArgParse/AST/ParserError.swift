//
//  ParserError.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

/// Error thrown during parsing (AST composition)
public enum ParserError: Error {
    case unexpected(token: Token)
    case unexepctedEnd
    case expecting(variantOf: [Token])
    case expecting(token: Token)
    case incorrectRootSubcommand(found: String, expecting: String)
}
