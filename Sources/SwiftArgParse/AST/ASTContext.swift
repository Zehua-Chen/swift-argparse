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
    public internal(set) var commandInfo: Command

    public init(from args: [String], commandInfo: Command) throws {
        self.commandInfo = commandInfo

        var parser = _Parser(args: args, rootCommand: commandInfo)
        try parser.parse(into: &self)
    }
}
