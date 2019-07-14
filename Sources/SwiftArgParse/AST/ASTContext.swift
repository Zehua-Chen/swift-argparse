//
//  AST.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//
public struct ASTContext {

    public enum Value: Equatable {
        case string(_ value: String)
        case boolean(_ value: Bool)
        case int(_ value: Int)
        case decimal(_ value: Double)
    }

    public static func `default`() throws -> ASTContext {
        return try ASTContext(from: CommandLine.arguments)
    }

    public internal(set) var subcommands = Set<String>()
    public internal(set) var requiredParams = Set<String>()
    public internal(set) var optionalParams = [String: Value]()

    public init(from args: [String]) throws {
        var parser = _Parser(args: args)
        try parser.parse(into: &self)
    }
}
