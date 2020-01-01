//
//  CommandLineApplication.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

import Foundation

public extension CommandLine {

    /// Run the command
    ///
    /// Only the [1...] arguments are parsed, since the first argument
    /// is always right.
    /// - Parameters:
    ///   - command: a command to run
    ///   - arguments: an array of arguments
    /// - Throws: any error
    static func run(_ command: Command, with arguments: [String] = CommandLine.arguments) {
        // Configure the application
        var config = Configuration()
        config.command = command
        command.setup(with: config)

        // Parse AST
        var context: _ASTContext

        do {
            context = try _ASTContext(args: arguments[1...])
        } catch {
            _printASTError(error, args: arguments[...])
        }

        // Semantic Stages
        _PathProcessor().run(on: &context, with: config)

        // Trace the path
        // _PathProcessor should ensure that all paths are at the beginning
        // of the ast elements and all paths are valid
        for case .some(let element) in context.elements {
            guard case .path(let path) = element else { break }

            config = config.children[path.value]!
        }

        do {
            try _OptionProcessor().run(on: &context, with: config)
            // If --help is printed, then there probabily are something wrong with provided
            // parameters, therefore help must be print here if possible
            _tryPrintHelp(in: context, from: config)
            try _ParameterChecker().run(on: context, with: config)
        } catch {
            _printSemanticError(error, arguments[...])
            _printHelp(from: config)
        }

        let commandContext = CommandContext(astContext: context, config: config)
        config.command?.run(with: commandContext)
    }

    /// Print error information
    ///
    /// - Parameters:
    ///   - error: error to print
    ///   - config: the current cnfiguration
    ///   - args: the full command line argument, including the execution name
    fileprivate static func _printSemanticError(
        _ error: Error,
        _ args: ArraySlice<String>)
    {
        switch error {
        case ParameterError.notEnoughParameters:
            print("Not enough parameters", to: &StandardErrorTextOutputStream.default)
        case ParameterError.tooManyParameters:
            print("Too many parameters", to: &StandardErrorTextOutputStream.default)
        case ParameterError.typeMismatch(let index, let expecting, let found, _):
            print(
                "\(index)st parameter type mismatch, expecting \(expecting), found \(found)",
                to: &StandardErrorTextOutputStream.default)
        case ParameterError.unrecognized(let index, _):
            print("Unrecognized \(index)st parameter", to: &StandardErrorTextOutputStream.default)
        case OptionError.unrecogznied(let name, _):
            print("Unrecognized \(name) option", to: &StandardErrorTextOutputStream.default)
        case OptionError.typeMismatch(let name, let expecting, let found, _):
            print(
                "Option \(name) type mismatch, expecting \(expecting), found \(found)",
                to: &StandardErrorTextOutputStream.default)
        default:
            break
        }
    }

    /// Display AST error
    /// - Parameters:
    ///   - error: the AST error
    ///   - args: the argument to the command line
    fileprivate static func _printASTError(_ error: Error, args: ArraySlice<String>) -> Never {
        print("\(error)", to: &StandardErrorTextOutputStream.default)
        exit(1)
    }

    /// Print help information if AST context contains "--help" option
    /// - Parameters:
    ///   - context: the AST context parsed from the command line
    ///   - config: configuration to print with
    fileprivate static func _tryPrintHelp(in context: _ASTContext, from config: Configuration) {
        for case .some(.option(let option)) in context.elements {
            if option.name == "--help" {
                _printHelp(from: config)
            }
        }
    }

    /// Print help information and exit the process with 1
    /// - Parameter config: the configuration
    fileprivate static func _printHelp(from config: Configuration) -> Never {
        print(config, to: &StandardErrorTextOutputStream.default)
        exit(1)
    }
}
