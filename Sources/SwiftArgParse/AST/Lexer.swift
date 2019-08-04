//
//  Lexer.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/7/19.
//

import SwiftQueue

extension Queue {
    var isEmpty: Bool {
        return self.count <= 0
    }
}

internal struct _Lexer {
    /// A "true" string literal, used to parse booleans
    fileprivate static let _trueLiteral = "true"
    /// A "false" string literal, used to parse booleans
    fileprivate static let _falseLiteral = "false"

    /// The source that the lexer gets input from
    fileprivate var _source: _Source
    /// The current source item being processed
    fileprivate var _item: _Source.Item?

    fileprivate var _queue = Queue<Token>()

    fileprivate var _buffer: String = ""

    fileprivate var _isLastEndBlockReturned = false

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
    internal mutating func next() throws -> Token? {
        if _queue.isEmpty {
            return try _extract()
        }

        return _queue.dequeue()
    }

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
        guard _item != nil else {
            if !_isLastEndBlockReturned {
                _isLastEndBlockReturned = true
                return .endBlock
            }
            
            return nil
        }

        _buffer = ""

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
        case .endBlock:
            _item = _source.next()
            return .endBlock
        }
    }

    // MARK: Token handlers

    /// Handles string tokens
    ///
    /// - Returns: a token, if there is one
    /// - Throws: `ParserError`
    fileprivate mutating func _string() throws -> Token? {

        while _item != nil && _item! != .endBlock {
            switch _item! {
            case .character(let c):
                switch c {
                case "=":
                    return .string(_buffer)
                default:
                    _buffer.append(c)
                }
            // '=' is a token, must return and not enumerate
            case .endBlock:
                break
            }

            _item = _source.next()
        }

        return .string(_buffer)
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

        while _item != nil && _item! != .endBlock {

            switch _item! {
            case .character(let c):
                if c != literal[index] {
                    return try _string()
                }

                _buffer.append(c)
            case .endBlock:
                break
            }

            _item = _source.next()
            literal.formIndex(after: &index)

            if index == endIndex {
                return .boolean(value)
            }
        }

        return .string(_buffer)
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

                return Token.udecimal(d)
            } else {
                guard let i = UInt(_buffer) else {
                    throw LexerError.unableToParseNumber
                }

                return Token.uint(i)
            }
        }

        while _item != nil && _item! != .endBlock {

            switch _item! {
            case .character(let c):
                if c == "." {
                    isDecimal = true
                }
                
                _buffer.append(c)
            case .endBlock:
                return try compose()
            }

            _item = _source.next()
        }

        return try compose()
    }
}
