//
//  Lexer.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/7/19.
//

internal struct _Lexer {
    /// A "true" string literal, used to parse booleans
    fileprivate static let _trueLiteral = "true"
    /// A "false" string literal, used to parse booleans
    fileprivate static let _falseLiteral = "false"

    /// The source that the lexer gets input from
    fileprivate var _source: _Source
    /// The current source item being processed
    fileprivate var _item: _Source.Item?

    /// Create a new lexer using a specified source
    ///
    /// - Parameter source: the source to provide data to the lexer
    internal init(using source: _Source) {
        _source = source
        _item = _source.next()
    }

    /// Get the next token from the lexer, if there is one. Otherwise, returns
    /// nil
    ///
    /// - Returns: a token if there is one
    /// - Throws: `ParserError`
    internal mutating func next() throws -> _Token? {
        // If _item is nil then returns
        guard _item != nil else { return nil }

        // Process _item accordingly
        switch _item! {
        case .character(let c):
            switch c {
            case "=":
                _item = _source.next()
                return .assignment
            case "-":
                _item = _source.next()
                return .dash
            case "t":
                return try _boolean(literal: _Lexer._trueLiteral, value: true)
            case "f":
                return try _boolean(literal: _Lexer._falseLiteral, value: false)
            case "a"..."z", "A"..."Z":
                return try _string()
            case "0"..."9", ".":
                return try _number()
            // if character is not recognized, throws ParserError
            default:
                throw LexerError.unexpected(character: c)
            }
        case .blockSeparator:
            _item = _source.next()
            return .blockSeparator
        }
    }

    // MARK: Token handlers

    /// Handles string tokens
    ///
    /// - Returns: a token, if there is one
    /// - Throws: `ParserError`
    fileprivate mutating func _string() throws -> _Token? {
        var buffer = ""

        while _item != nil && _item! != .blockSeparator {
            switch _item! {
            case .character(let c):
                switch c {
                case "a"..."z", "A"..."Z", " ":
                    buffer.append(c)
                case "=":
                    return .string(buffer)
                default:
                    throw LexerError.unexpected(character: c)
                }
            // '=' is a token, must return and not enumerate
            case .blockSeparator:
                return .string(buffer)
            }

            _item = _source.next()
        }

        return .string(buffer)
    }

    /// Handles boolean token
    ///
    /// - Parameters:
    ///   - literal: a string representation of a boolean literal
    ///   - value: the boolean value to returns
    /// - Returns: a token, if there is one
    /// - Throws: `ParserError`
    fileprivate mutating func _boolean(literal: String, value: Bool) throws -> _Token? {
        var index = literal.startIndex
        let endIndex = literal.endIndex

        while _item != nil && _item! != .blockSeparator {

            switch _item! {
            case .character(let c):
                if c != literal[index] {
                    throw LexerError.unexpected(character: c)
                }
            case .blockSeparator:
                break
            }

            _item = _source.next()
            literal.formIndex(after: &index)

            if index == endIndex {
                return .boolean(value)
            }
        }

        throw LexerError.expecting(string: literal)
    }

    /// Parse an **unsigned** number token, `-` is treated as dash
    ///
    /// - Returns: a token, if there is one
    /// - Throws: `ParserError`
    fileprivate mutating func _number() throws -> _Token? {
        var isDecimal = false
        var buffer = ""

        /// Compose a number token
        ///
        /// - Returns: a number token
        /// - Throws: `ParserError`
        func compose() throws -> _Token {
            if isDecimal {
                guard let d = Double(buffer) else {
                    throw LexerError.unableToParseNumber
                }

                return _Token.udecimal(d)
            } else {
                guard let i = UInt(buffer) else {
                    throw LexerError.unableToParseNumber
                }

                return _Token.uint(i)
            }
        }

        while _item != nil && _item! != .blockSeparator {

            switch _item! {
            case .character(let c):
                if c == "." {
                    isDecimal = true
                }
                
                buffer.append(c)
            case .blockSeparator:
                return try compose()
            }

            _item = _source.next()
        }

        return try compose()
    }
}
