//
//  CommandLineApplication.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

import Foundation

public extension CommandLine {
    static func run(_ command: Command) {
        // Configure the application
        let config = Configuration()
        command.setup(with: config)

        // Parse AST
        var context = try! _ASTContext(args: self.arguments[1...])

        // Semantic Stages
        _PathProcessor().run(on: &context, with: config)

        print(context.elements)
    }
}
