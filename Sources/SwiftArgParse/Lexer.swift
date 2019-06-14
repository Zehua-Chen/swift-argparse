//
//  File.swift
//  
//
//  Created by Zehua Chen on 6/7/19.
//

internal struct _Lexer {
    fileprivate var _source: _Source
    fileprivate var _letter: _Source.Letter?

    internal init(using source: _Source) {
        _source = source
    }

    internal mutating func next() -> _Token? {
        if _letter == nil {
            _letter = _source.next()
            // End of source
            guard _letter != nil else { return nil }
        }

        switch _letter! {
        case .letter(let c):
            switch c {
            case "=":
                _letter = _source.next()
                return .assignment
            case "-":
                _letter = _source.next()
                return .dash
            case "a"..."z", "A"..."Z":
                return _string()
            default:
                return nil
            }
        case .blockSeparator:
            _letter = _source.next()
            return self.next()
        }
    }

    // MARK: Token handlers

    fileprivate mutating func _string() -> _Token? {
        var buffer = ""

        loop: while _letter != nil && _letter! != .blockSeparator {
            switch _letter! {
            case .letter(let c):
                switch c {
                case "a"..."z", "A"..."Z", " ":
                    buffer.append(c)
                case "=":
                    return .string(buffer)
                default:
                    return nil
                }
            case .blockSeparator:
                return .string(buffer)
            }

            _letter = _source.next()
        }

        return .string(buffer)
    }

    // MARK: Enumeration helpers
}
