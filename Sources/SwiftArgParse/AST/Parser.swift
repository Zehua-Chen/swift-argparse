//
//  Parser.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

fileprivate typealias _Primitive = _ASTContext.Primitive
fileprivate typealias _Option = _ASTContext.Option

internal struct _Parser {

    fileprivate var _lexer: _Lexer
    fileprivate var _buffer = ""

    /// Create a new parser from given command line args
    ///
    /// - Parameter args: the command line args to use
    internal init(args: ArraySlice<String>) {
        _lexer = _Lexer(source: _Source(input: args))
    }

    /// Parse into an ast context
    ///
    /// - Parameter context: the AST context to receive the results
    /// - Throws: `ParserError` or `LexerError`
    internal mutating func parse(into context: inout _ASTContext) throws {
        // Each handler is supposed to
        // - Handle the iteration of self._token
        // - Make sure the self._token to be handled in the next iteration is
        //   not _Token.blockSeparator, as a block separtor is supposed to end
        //   a declaration
        while let peek = try _lexer.peek() {
            _buffer = ""
            
            switch peek.value {
            case .dash:
                try _dashStart(into: &context)
            case .string(_):
                try _string(into: &context)
            case .udouble(_), .uint(_), .boolean(_):
                try _unsignedNonStrings(into: &context)
            default:
                break
            }
        }
    }

    fileprivate mutating func _string(into context: inout _ASTContext) throws {
        var token = try _lexer.next()

        guard token != nil else { throw ParserError.unexepctedEnd }
        guard case .string(let str) = token!.value else {
            throw ParserError.expecting(tokenValueType: .string, location: token!.location)
        }

        let tokenLocation = token!.location

        token = try _lexer.next()

        guard token != nil else { throw ParserError.unexepctedEnd }
        guard .endBlock == token!.value else {
            throw ParserError.expecting(tokenValueType: .endBlock, location: token!.location)
        }

        context.append(_Primitive(value: str, location: tokenLocation))
    }

    fileprivate mutating func _dashStart(into context: inout _ASTContext) throws {
        var token = try _lexer.next()
        let startLocation = token!.location

        _buffer.append("-")

        let peek = try _lexer.peek()

        guard peek != nil else { throw ParserError.unexepctedEnd }

        switch peek!.value {
        case .dash, .string(_):
            return try _namedParam(into: &context, startsAt: startLocation)
        case .udouble(let ud):
            let _ = try _lexer.next()
            context.append(_Primitive(
                value: Double(ud) * -1.0,
                location: startLocation.joined(with: peek!.location)))
        case .uint(let ui):
            let _ = try _lexer.next()
            context.append(_Primitive(
                value: Int(ui) * -1,
                location: startLocation.joined(with: peek!.location)))
        default:
            throw ParserError.unexpected(token: peek!)
        }

        token = try _lexer.next()

        guard token != nil else { throw ParserError.unexepctedEnd }
        guard .endBlock == token!.value else {
            throw ParserError.expecting(tokenValueType: .endBlock, location: token!.location)
        }
    }

    fileprivate mutating func _namedParam(into context: inout _ASTContext, startsAt: SourceLocation) throws {
        var token = try _lexer.next()
        // Gather dashes
        while token != nil && .dash == token!.value {
            _buffer.append("-")
            token = try _lexer.next()
        }

        // Gather name
        guard token != nil else { throw ParserError.unexepctedEnd }
        guard case .string(let name) = token!.value else {
            throw ParserError.unexpected(token: token!)
        }

        _buffer.append(name)
        let endLocation = token!.location

        // Gather assignment expression
        token = try _lexer.next()
        guard token != nil else { throw ParserError.unexepctedEnd }

        switch token!.value {
        case .endBlock:
            context.append(_Option(
                name: _buffer,
                value: nil,
                location: startsAt.joined(with: endLocation)))
            return
        case .assignment:
            token = try _lexer.next()
        default:
            throw ParserError.unexpected(token: token!)
        }

        guard token != nil else { throw ParserError.unexepctedEnd }

        switch token!.value {
        case .string(let str):
            context.append(_Option(
                name: _buffer,
                value: str,
                location: startsAt.joined(with: token!.location)))
        case .uint(let ui):
            context.append(_Option(
                name: _buffer,
                value: Int(ui),
                location: startsAt.joined(with: token!.location)))
        case .udouble(let ud):
            context.append(_Option(
                name: _buffer,
                value: Double(ud),
                location: startsAt.joined(with: token!.location)))
        case .boolean(let b):
            context.append(_Option(
                name: _buffer,
                value: b,
                location: startsAt.joined(with: token!.location)))
        case .dash:
            token = try _lexer.next()

            guard token != nil else { throw ParserError.unexepctedEnd }

            switch token!.value {
            case .udouble(let ud):
                context.append(_Option(
                    name: _buffer,
                    value: Double(ud) * -1.0,
                    location: startsAt.joined(with: token!.location)))
            case .uint(let ui):
                context.append(_Option(
                    name: _buffer,
                    value: Int(ui) * -1,
                    location: startsAt.joined(with: token!.location)))
            default:
                throw ParserError.unexpected(token: token!)
            }
        default:
            throw ParserError.unexpected(token: token!)
        }

        // Get endblock or nil
        token = try _lexer.next()

        guard token != nil else { throw ParserError.unexepctedEnd }
        guard token!.value == .endBlock else {
            throw ParserError.expecting(tokenValueType: .endBlock, location: token!.location)
        }
    }

    fileprivate mutating func _unsignedNonStrings(into context: inout _ASTContext) throws {
        var token = try _lexer.next()

        guard token != nil else { throw ParserError.unexepctedEnd }

        switch token!.value {
        case .boolean(let b):
            context.append(_Primitive(value: b, location: token!.location))
        case .uint(let ui):
            context.append(_Primitive(value: Int(ui), location: token!.location))
        case .udouble(let ud):
            context.append(_Primitive(value: Double(ud), location: token!.location))
        default:
            throw ParserError.unexpected(token: token!)
        }

        token = try _lexer.next()

        guard token != nil else { throw ParserError.unexepctedEnd }
        guard token!.value == .endBlock else { throw ParserError.unexpected(token: token! )}
    }
}
