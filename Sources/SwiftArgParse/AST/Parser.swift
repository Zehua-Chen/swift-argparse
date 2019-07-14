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

    internal init(args: [String]) {
        _lexer = _Lexer(using: _Source(using: args[0...]))
        _token = try! _lexer.next()
    }

    internal mutating func parse(into context: inout ASTContext) throws {

        while _token != nil {
            switch _token! {
            case .string(let str):
                context.subcommands.insert(str)
                _token = try _lexer.next()
            case .dash:
                try _optionalParam(context: &context)
            default:
                break
            }
        }
    }

    internal mutating func _optionalParam(context: inout ASTContext) throws {
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
                    // TODO: Handle error
                    break
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
                    // TODO: Handle error
                    break
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
                    // TODO: Handle error
                    break
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
                    // TODO: Handle error
                    break
                }

                state = .expectingBlockSeparator
            case .expectingBlockSeparator:
                if case .blockSeparator = _token! {
                    _token = try _lexer.next()
                    return
                }
                // TODO: Handle error
            }

            _token = try _lexer.next()
        }
    }
}
