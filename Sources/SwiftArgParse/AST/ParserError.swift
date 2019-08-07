//
//  ParserError.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

/// Error thrown during parsing (AST composition)
public enum ParserError: Error, CustomStringConvertible {
    case unexpected(token: Token)
    case unexepctedEnd
    case expecting(token: Token)
    case incorrectRootSubcommand(found: String, expecting: String)

    public var description: String {
        switch self {
        case .unexpected(let token):
            return "unexpected \(token)"
        case .unexepctedEnd:
            return "unexpected end"
        case .expecting(let token):
            return "expecting token \(token)"
        case .incorrectRootSubcommand(let found, let expecting):
            return "expecting root command \(expecting), but found \(found)"
        }
    }
}
