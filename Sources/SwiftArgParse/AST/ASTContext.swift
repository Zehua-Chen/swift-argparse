//
//  AST.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

public struct ASTContext {

    public typealias OptionalParamsType = [String:Any]

    public internal(set) var subcommands = [String]()
    public internal(set) var requiredParams = [Any]()
    public internal(set) var optionalParams = OptionalParamsType()

    internal init(from args: [String], root: _CommandNode) throws {
        var parser = _Parser(args: args, rootCommand: root)
        try parser.parse(into: &self)
    }

    internal init(
        subcommands: [String],
        requiredParams: [Any],
        optionalParams: [String:Any]
    ) {
        self.subcommands = subcommands
        self.requiredParams = requiredParams
        self.optionalParams = optionalParams
    }
}
