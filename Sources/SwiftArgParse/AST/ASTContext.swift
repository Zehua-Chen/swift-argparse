//
//  AST.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

public struct ASTContext {

    public internal(set) var subcommands = [String]()
    public internal(set) var requiredParams = [Any]()
    public internal(set) var optionalParams = [String:Any]()
    public internal(set) var command: Command

    public init(from args: [String], command: Command) throws {
        self.command = command

        var parser = _Parser(args: args, rootCommand: command)
        try parser.parse(into: &self)
    }

    public init(
        subcommands: [String],
        requiredParams: [Any],
        optionalParams: [String:Any],
        command: Command
    ) {
        self.subcommands = subcommands
        self.requiredParams = requiredParams
        self.optionalParams = optionalParams
        self.command = command
    }
}
