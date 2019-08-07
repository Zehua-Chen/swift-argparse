//
//  Parser.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

internal struct _Parser {

    fileprivate enum _Region {
        case subcommand
        case params
    }

    fileprivate var _lexer: _Lexer
    fileprivate var _buffer = ""
    fileprivate var _isRootCommandNode = true
    fileprivate var _commandNode: _CommandNode
    fileprivate var _region = _Region.subcommand

    /// Create a new parser from given command line args
    ///
    /// - Parameter args: the command line args to use
    internal init(args: [String], rootCommand: _CommandNode) {
        _lexer = _Lexer(source: _Source(input: args[0...]))
        _commandNode = rootCommand
    }

    /// Parse into an ast context
    ///
    /// - Parameter context: the AST context to receive the results
    /// - Throws: `ParserError` or `LexerError`
    internal mutating func parse(into context: inout ASTContext) throws {
        // Each handler is supposed to
        // - Handle the iteration of self._token
        // - Make sure the self._token to be handled in the next iteration is
        //   not _Token.blockSeparator, as a block separtor is supposed to end
        //   a declaration
        while let peek = try _lexer.peek() {
            _buffer = ""
            
            switch peek {
            case .dash:
                try _dashStart(into: &context)
            case .string(_):
                try _string(into: &context)
            case .udecimal(_), .uint(_), .boolean(_):
                try _unsignedNonStringUnnamedParam(into: &context)
            default:
                throw ParserError.unexpected(token: peek)
            }
        }
    }

    fileprivate mutating func _dashStart(into context: inout ASTContext) throws {
        guard let token = try _lexer.next() else {
            throw ParserError.unexepctedEnd
        }

        switch token {
        case .dash:
            _buffer.append("-")

            if let peek = try _lexer.peek() {
                switch peek {
                case .dash, .string(_):
                    return try _namedParam(into: &context)
                case .udecimal(let ud):
                    context.unnamedParams.append(Double(ud) * -1.0)
                case .uint(let ui):
                    context.unnamedParams.append(Int(ui) * -1)
                default:
                    throw ParserError.unexpected(token: token)
                }
            }
        default:
            throw ParserError.unexpected(token: token)
        }
    }

    fileprivate mutating func _namedParam(into context: inout ASTContext) throws {
        var token = try _lexer.next()
        // Gather dashes
        while token != nil && .dash == token! {
            _buffer.append("-")
            token = try _lexer.next()
        }

        // Gather name
        guard token != nil else { throw ParserError.unexepctedEnd }
        guard case .string(let name) = token! else {
            throw ParserError.unexpected(token: token!)
        }

        _buffer.append(name)

        // Gather assignment expression
        token = try _lexer.next()
        guard token != nil else { throw ParserError.unexepctedEnd }

        switch token! {
        case .endBlock:
            // If there are at least two more tokens ahead, the following
            // syntax rules apply:
            // - if peek_1 is dash and peek_2 is string or dash, then insert
            //   a true named param using the existing name
            // - Otherwise, the upcoming block is considered to be a value
            //   to be inserted as an named param using the current name
            // If there are no sufficient tokens ahead, then insert a "true"
            // named param using the existing name
            var shouldInsertBool = false

            if let peekA = try _lexer.peek(), let peekB = try _lexer.peek(offset: 1) {
                if peekA == .dash {
                    switch peekB {
                    case .string(_), .dash:
                        shouldInsertBool = true
                        return
                    default:
                        break
                    }
                }
            } else {
                shouldInsertBool = true
            }

            if shouldInsertBool {
                context.namedParams[_buffer] = true
                return
            } else {
                // Since if up coming value serves as a value in a named
                // param, the current token functions as a assignment
                // token. Therefore, the same action has to be performed as
                // if it is an assignment token.
                token = try _lexer.next()
            }
        case .assignment:
            token = try _lexer.next()
        default:
            throw ParserError.unexpected(token: token!)
        }

        guard token != nil else { throw ParserError.unexepctedEnd }

        switch token! {
        case .string(let str):
            context.namedParams[_buffer] = str
        case .uint(let ui):
            context.namedParams[_buffer] = Int(ui)
        case .udecimal(let ud):
            context.namedParams[_buffer] = Double(ud)
        case .boolean(let b):
            context.namedParams[_buffer] = b
        case .dash:
            token = try _lexer.next()

            guard token != nil else { throw ParserError.unexepctedEnd }

            switch token! {
            case .udecimal(let ud):
                context.namedParams[_buffer] = Double(ud) * -1.0
            case .uint(let ui):
                context.namedParams[_buffer] = Int(ui) * -1
            default:
                throw ParserError.unexpected(token: token!)
            }
        default:
            throw ParserError.unexpected(token: token!)
        }

        // Get endblock or nil
        token = try _lexer.next()

        guard token != nil else { throw ParserError.unexepctedEnd }
        guard token! == .endBlock else {
            throw ParserError.expecting(token: .endBlock)
        }
    }

    fileprivate mutating func _unsignedNonStringUnnamedParam(into context: inout ASTContext) throws {
        var token = try _lexer.next()
        guard token != nil else { throw ParserError.unexepctedEnd }

        switch token! {
        case .boolean(let b):
            context.unnamedParams.append(b)
        case .uint(let ui):
            context.unnamedParams.append(Int(ui))
        case .udecimal(let ud):
            context.unnamedParams.append(Double(ud))
        default:
            throw ParserError.unexpected(token: token!)
        }

        token = try _lexer.next()
        guard token != nil else { throw ParserError.unexepctedEnd }
        guard token! == .endBlock else { throw ParserError.unexpected(token: token! )}
    }

    fileprivate mutating func _string(into context: inout ASTContext) throws {
        var token = try _lexer.next()
        guard token != nil else { throw ParserError.unexepctedEnd }
        guard case .string(let str) = token! else {
            throw ParserError.expecting(token: .string(""))
        }

        switch _region {
        case .subcommand:
            if _isRootCommandNode {
                guard str == _commandNode.name else {
                    throw ParserError.incorrectRootSubcommand(found: str, expecting: _commandNode.name)
                }

                _isRootCommandNode = false
                context.subcommands.append(str)

                break
            }

            if _commandNode.containsSubcommand(str) {
                context.subcommands.append(str)
                _commandNode = _commandNode.children[str]!
            } else {
                _region = .params
                context.unnamedParams.append(str)
            }
        case .params:
            context.unnamedParams.append(str)
        }

        token = try _lexer.next()
        guard token != nil else { throw ParserError.unexepctedEnd }
        guard token! == .endBlock else { throw ParserError.unexpected(token: token! )}
    }
}
