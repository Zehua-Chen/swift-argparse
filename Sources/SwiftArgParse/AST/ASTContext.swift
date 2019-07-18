//
//  AST.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

public enum ParamValue: Equatable, Hashable {
    case string(_ value: String)
    case boolean(_ value: Bool)
    case int(_ value: Int)
    case decimal(_ value: Double)
}

public struct ASTContext {

    public internal(set) var subcommands = [String]()
    public internal(set) var requiredParams = [ParamValue]()
    public internal(set) var optionalParams = [String: ParamValue]()
    public internal(set) var commandInfo: Command

    public init(from args: [String], commandInfo: Command) throws {
        self.commandInfo = commandInfo

        var parser = _Parser(args: args, rootCommand: commandInfo)
        try parser.parse(into: &self)
    }
}
