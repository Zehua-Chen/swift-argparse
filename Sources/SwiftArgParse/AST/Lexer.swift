//
//  Lexer.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/7/19.
//

import SwiftQueue

/// The lexer
internal struct _Lexer {
    /// A "true" string literal, used to parse booleans
    fileprivate static let _trueLiteral = "true"
    /// A "false" string literal, used to parse booleans
    fileprivate static let _falseLiteral = "false"

    /// The source that the lexer gets input from
    fileprivate var _source: _Source

    /// The current source item being processed
    fileprivate var _element: _Source.Element?

    /// The start point of current token
    fileprivate var _startPoint = SourcePoint(block: 0, index: 0)
    fileprivate var _prevPoint = SourcePoint(block: 0, index: 0)

    /// A queue of buffered tokens waiting to be nexted
    fileprivate var _queue = Queue<Token>()

    /// Buffer used to help lexing
    fileprivate var _buffer = ""

    /// Create a new lexer using a specified source
    ///
    /// - Parameter source: the source to provide data to the lexer
    internal init(source: _Source) {
        _source = source
        _element = _source.next()
    }

    /// Get the next token from the lexer, if there is one. Otherwise, returns
    /// nil
    ///
    /// - Returns: a token if there is one
    /// - Throws: `ParserError`
    internal mutating func next() throws -> Token? {
        if _queue.isEmpty {
            return try _extract()
        }

        return _queue.dequeue()
    }

    /// Peek into the next token
    /// - Parameter offset: how much to peek into, offset 0 gives the next token
    internal mutating func peek(offset: Int = 0) throws -> Token? {
        let count = offset + 1
        
        if count > _queue.count {
            var diff = _queue.count - count
            diff = diff < 0 ? 1 : diff

            for _ in 0..<diff {
                if let token = try _extract() {
                    _queue.enqueue(token)
                }
            }
        }

        return _queue.peek(offset: offset)
    }

    fileprivate mutating func _extract() throws -> Token? {
        // If _item is nil then returns
        guard _element != nil else { return nil }

        _buffer = ""
        _startPoint = _source.point

        // Process _item accordingly
        switch _element! {
        case .character(let c):
            switch c {
            case "=":
                _fetch()
                return Token(location: _startPoint..._startPoint, value: .assignment)
            case "-":
                _fetch()
                return Token(location: _startPoint..._startPoint, value: .dash)
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
        case .endBlock:
            _fetch()
            return Token(location: _startPoint..._startPoint, value: .endBlock)
        }
    }

    // MARK: Token handlers

    /// Handles string tokens
    ///
    /// - Returns: a token, if there is one
    /// - Throws: `ParserError`
    fileprivate mutating func _string() throws -> Token? {
        
        while _element! != .endBlock {
            switch _element! {
            case .endBlock:
                break
            case .character(let c):
                switch c {
                // '=' is a token, must return and not enumerate
                case "=":
                    return Token(location: _startPoint..._prevPoint, value: .string(_buffer))
                default:
                    _buffer.append(c)
                }
            }

            _fetch()
        }

        return Token(location: _startPoint..._prevPoint, value: .string(_buffer))
    }

    /// Handles boolean token
    ///
    /// - Parameters:
    ///   - literal: a string representation of a boolean literal
    ///   - value: the boolean value to returns
    /// - Returns: a token, if there is one
    /// - Throws: `ParserError`
    fileprivate mutating func _boolean(literal: String, value: Bool) throws -> Token? {
        var index = literal.startIndex
        let endIndex = literal.endIndex

        while _element! != .endBlock {

            switch _element! {
            case .character(let c):
                if c != literal[index] {
                    return try _string()
                }

                _buffer.append(c)
            case .endBlock:
                break
            }

            _fetch()
            literal.formIndex(after: &index)

            if index == endIndex {
                return Token(location: _startPoint..._prevPoint, value: .boolean(value))
            }
        }

        return try _string()
    }

    /// Parse an **unsigned** number token, `-` is treated as dash
    ///
    /// - Returns: a token, if there is one
    /// - Throws: `ParserError`
    fileprivate mutating func _number() throws -> Token? {
        var isDecimal = false
        _buffer = ""

        /// Compose a number token
        ///
        /// - Returns: a number token
        /// - Throws: `ParserError`
        func compose() throws -> Token {
            if isDecimal {
                guard let d = Double(_buffer) else {
                    throw LexerError.unableToParseNumber
                }

                return Token(location: _startPoint..._prevPoint, value: .udouble(d))
            } else {
                guard let i = UInt(_buffer) else {
                    throw LexerError.unableToParseNumber
                }

                return Token(location: _startPoint..._prevPoint, value: .uint(i))
            }
        }

        while _element! != .endBlock {

            switch _element! {
            case .character(let c):
                if c == "." {
                    isDecimal = true
                }

                _buffer.append(c)
            case .endBlock:
                return try compose()
            }

            _fetch()
        }

        return try compose()
    }

    /// Move to the next element
    fileprivate mutating func _fetch() {
        _prevPoint = _source.point
        _element = _source.next()
    }
}
