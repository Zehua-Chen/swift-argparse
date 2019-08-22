//
//  CommandLineApplication.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

import Foundation

public extension CommandLine {
    static func run(_ command: Command) throws {
        // Configure the application
        var config = Configuration()
        command.setup(with: config)

        // Parse AST
        var context = try! _ASTContext(args: self.arguments[1...])

        // Semantic Stages
        _PathProcessor().run(on: &context, with: config)

        // Trace the path
        // _PathProcessor should ensure that all paths are at the beginning
        // of the ast elements and all paths are valid
        for case .some(let element) in context.elements {
            guard case .path(let path) = element else { break }

            config = config.children[path.value]!
        }

        try _OptionProcessor().run(on: &context, with: config)
        try _ParameterChecker().run(on: context, with: config)

        config.command?.run(with: CommandContext(astContext: context, config: config))
    }
}
