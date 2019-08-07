//
//  AST.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

public struct ASTContext {
    public internal(set) var subcommands = [String]()
    public internal(set) var unnamedParams = [Any]()
    public internal(set) var namedParams = [String:Any]()

    internal init(from args: [String], root: _CommandNode) throws {
        var parser = _Parser(args: args, rootCommand: root)
        try parser.parse(into: &self)
    }

    public init(
        subcommands: [String],
        unnamedParams: [Any],
        namedParams: [String:Any]
    ) {
        self.subcommands = subcommands
        self.unnamedParams = unnamedParams
        self.namedParams = namedParams
    }
}
