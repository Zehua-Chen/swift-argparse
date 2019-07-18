//
//  Parser.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

internal struct _Parser {

    fileprivate var _lexer: _Lexer
    fileprivate var _nameBuffer = ""
    fileprivate var _token: _Token!
    fileprivate var _commandInfo: Command
    fileprivate var _isCommandInfoRoot = false

    /// Create a new parser from given command line args
    ///
    /// - Parameter args: the command line args to use
    internal init(args: [String], rootCommandInfo: Command) {
        _lexer = _Lexer(using: _Source(using: args[0...]))
        _token = try! _lexer.next()
        _commandInfo = rootCommandInfo
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
        while _token != nil {
            switch _token! {
            // Strings are considered to be subcommands.
            // Semantic stage will handle moving the strings to required
            // params
            case .string(_):
                try _subcommandOrRequiredParam(context: &context)
            case .boolean(_), .udecimal(_), .uint(_):
                try _requiredParamsWithoutDash(context: &context)
            case .dash:
                try _optionalParam(context: &context)
            default:
                throw ParserError.expectingStringOrDash
            }
        }
    }

    /// Handle subcommand
    ///
    /// - Parameter context: the context to receive the subcommand
    /// - Throws: `ParserError` or `LexerError`
    fileprivate mutating func _subcommandOrRequiredParam(context: inout ASTContext) throws {
        enum State {
            case expectingString
            case expectingBlockSeparator
        }

        var state = State.expectingString

        while _token != nil {
            switch state {
            case .expectingString:
                switch _token! {
                case .string(let str):
                    if !_isCommandInfoRoot {
                        if str == _commandInfo.name {
                            context.subcommands.append(str)
                            _isCommandInfoRoot = true
                        } else {
                            context.requiredParams.append(.string(str))
                        }
                    } else {
                        if _commandInfo.contains(subcommand: str) {
                            context.subcommands.append(str)
                            _commandInfo = _commandInfo.subcommands[str]!
                        } else {
                            context.requiredParams.append(.string(str))
                        }
                    }

                    state = .expectingBlockSeparator
                default:
                    throw ParserError.expectingString
                }
            case .expectingBlockSeparator:
                if case .blockSeparator = _token! {
                    _token = try _lexer.next()
                    return
                }
            }

            _token = try _lexer.next()
        }
    }

    /// Handle required params
    ///
    /// - Parameter context: the context to receive the subcommand
    /// - Throws: `ParserError` or `LexerError`
    fileprivate mutating func _requiredParamsWithoutDash(context: inout ASTContext) throws {
        enum State {
            case expectingValue
            case expectingBlockSeparator
        }

        var state = State.expectingValue

        while _token != nil {
            switch state {
            case .expectingValue:
                switch _token! {
                case .string(let str):
                    context.requiredParams.append(.string(str))
                case .boolean(let b):
                    context.requiredParams.append(.boolean(b))
                case .udecimal(let ud):
                    context.requiredParams.append(.decimal(Double(ud)))
                case .uint(let ui):
                    context.requiredParams.append(.int(Int(ui)))
                default:
                    throw ParserError.expectingString
                }

                state = .expectingBlockSeparator
            case .expectingBlockSeparator:
                if case .blockSeparator = _token! {
                    _token = try _lexer.next()
                    return
                }
            }

            _token = try _lexer.next()
        }
    }

    /// Handle optional parameter
    ///
    /// - Parameter context: the context to receive the optional parameter
    /// - Throws: `ParserError` or `LexerError`
    fileprivate mutating func _optionalParam(context: inout ASTContext) throws {
        enum State {
            case expectingName
            case expectingAssignmentOrBlockSeparator
            case expectingValue
            case expectingNegativeValue
            case expectingBlockSeparator
        }

        _nameBuffer = ""
        var state = State.expectingName

        while _token != nil {
            switch state {
            case .expectingName:
                switch _token! {
                case .string(let str):
                    _nameBuffer.append(str)
                    state = .expectingAssignmentOrBlockSeparator
                case .dash:
                    _nameBuffer.append("-")
                default:
                    throw ParserError.expectingStringOrDash
                }
            case .expectingAssignmentOrBlockSeparator:
                switch _token! {
                case .assignment:
                    state = .expectingValue
                case .blockSeparator:
                    context.optionalParams[_nameBuffer] = .boolean(true)
                    _token = try _lexer.next()
                    return
                default:
                    throw ParserError.expectingAssignmentOrBlockSeparator
                }
            case .expectingValue:
                switch _token! {
                case .boolean(let b):
                    context.optionalParams[_nameBuffer] = .boolean(b)
                    state = .expectingBlockSeparator
                case .string(let str):
                    context.optionalParams[_nameBuffer] = .string(str)
                    state = .expectingBlockSeparator
                case .udecimal(let ud):
                    context.optionalParams[_nameBuffer] = .decimal(Double(ud))
                    state = .expectingBlockSeparator
                case .uint(let ui):
                    context.optionalParams[_nameBuffer] = .int(Int(ui))
                    state = .expectingBlockSeparator
                case .dash:
                    state = .expectingNegativeValue
                default:
                    throw ParserError.expectingValue
                }

            case .expectingNegativeValue:
                switch _token! {
                case .boolean(let b):
                    context.optionalParams[_nameBuffer] = .boolean(b)
                case .string(let str):
                    context.optionalParams[_nameBuffer] = .string(str)
                case .udecimal(let ud):
                    context.optionalParams[_nameBuffer] = .decimal(Double(ud) * -1.0)
                case .uint(let ui):
                    context.optionalParams[_nameBuffer] = .int(Int(ui) * -1)
                default:
                    throw ParserError.expectingValue
                }

                state = .expectingBlockSeparator
            case .expectingBlockSeparator:
                if case .blockSeparator = _token! {
                    _token = try _lexer.next()
                    return
                }

                throw ParserError.expectingBlockSeparator
            }

            _token = try _lexer.next()
        }
    }
}
