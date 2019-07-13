//
//  Lexer.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/7/19.
//

internal struct _Lexer {
    fileprivate static let _trueLiteral = "true"
    fileprivate static let _falseLiteral = "false"

    fileprivate var _source: _Source
    fileprivate var _letter: _Source.Item?

    internal init(using source: _Source) {
        _source = source
    }

    internal mutating func next() throws -> _Token? {
        if _letter == nil {
            _letter = _source.next()
            // End of source
            guard _letter != nil else { return nil }
        }

        switch _letter! {
        case .character(let c):
            switch c {
            case "=":
                _letter = _source.next()
                return .assignment
            case "-":
                _letter = _source.next()
                return .dash
            case "t":
                return try _boolean(literal: _Lexer._trueLiteral, value: true)
            case "f":
                return try _boolean(literal: _Lexer._falseLiteral, value: false)
            case "a"..."z", "A"..."Z":
                return try _string()
            default:
                throw ParserError.unexpected(character: c)
            }
        case .blockSeparator:
            _letter = _source.next()
            return try self.next()
        }
    }

    // MARK: Token handlers

    fileprivate mutating func _string() throws -> _Token? {
        var buffer = ""

        while _letter != nil && _letter! != .blockSeparator {
            switch _letter! {
            case .character(let c):
                switch c {
                case "a"..."z", "A"..."Z", " ":
                    buffer.append(c)
                case "=":
                    return .string(buffer)
                default:
                    throw ParserError.unexpected(character: c)
                }
            // '=' is a token, must return and not enumerate
            case .blockSeparator:
                return .string(buffer)
            }

            _letter = _source.next()
        }

        return .string(buffer)
    }

    fileprivate mutating func _boolean(literal: String, value: Bool) throws -> _Token? {
        var index = literal.startIndex
        let endIndex = literal.endIndex

        while _letter != nil && _letter! != .blockSeparator {

            switch _letter! {
            case .character(let c):
                if c != literal[index] {
                    throw ParserError.unexpected(character: c)
                }
            case .blockSeparator:
                break
            }

            _letter = _source.next()
            literal.formIndex(after: &index)

            if index == endIndex {
                return .boolean(value)
            }
        }

        throw ParserError.expecting(string: literal)
    }
}
