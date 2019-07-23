//
//  AST.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

public enum ParamType: Equatable {
    case string
    case boolean
    case int
    case decimal
}

public enum ParamValue: Equatable, Hashable {
    case string(_ value: String)
    case boolean(_ value: Bool)
    case int(_ value: Int)
    case decimal(_ value: Double)

    var type: ParamType {
        switch self {
        case .string(_):
            return .string
        case .boolean(_):
            return .boolean
        case .decimal(_):
            return .decimal
        case .int(_):
            return .int
        }
    }

    func `is`(type: ParamType) -> Bool {
        switch self {
        case .string(_):
            return type == .string
        case .boolean(_):
            return type == .boolean
        case .decimal(_):
            return type == .decimal
        case .int(_):
            return type == .int
        }
    }
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
