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
    static func run(_ command: Command, with arguments: [String] = CommandLine.arguments) throws {
        // Configure the application
        var config = Configuration()
        config.command = command
        command.setup(with: config)

        // Parse AST
        var context = try! _ASTContext(args: arguments[1...])

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
            try _ParameterChecker().run(on: context, with: config)
        } catch {
            onError(error, config, arguments[1...])
            return
        }

        let commandContext = CommandContext(astContext: context, config: config)

        if commandContext.options["--help"] as! Bool {
            print(config)
            return
        }

        config.command?.run(with: commandContext)
    }

    fileprivate static func onError(_ error: Error, _ config: Configuration, _ args: ArraySlice<String>) {
        switch error {
        case ParameterError.notEnoughParameters:
            print("Not enough parameters")
        case ParameterError.tooManyParameters:
            print("Too many parameters")
        case ParameterError.typeMismatch(let index, let expecting, let found, _):
            print("\(index)st parameter type mismatch, expecting \(expecting), found \(found)")
        case ParameterError.unrecognized(let index, _):
            print("Unrecognized \(index)st parameter")
        case OptionError.unrecogznied(let name, _):
            print("Unrecognized \(name) option")
        case OptionError.typeMismatch(let name, let expecting, let found, _):
            print("Option \(name) type mismatch, expecting \(expecting), found \(found)")
        default:
            break
        }

        print(config)
    }
}
