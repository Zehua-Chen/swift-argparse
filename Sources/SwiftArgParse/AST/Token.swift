//
//  Token.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/7/19.
//

/// Token generaged by the Lexer
public struct Token: Equatable, CustomStringConvertible {

    public enum ValueType: Equatable {
        case string
        case boolean
        case uint
        case double
        case dash
        case assignment
        case endBlock
    }

    /// Value of the token
    public enum Value: Equatable, CustomStringConvertible {
        case string(_ value: String)
        case boolean(_ value: Bool)
        case uint(_ value: UInt)
        case udouble(_ value: Double)
        case dash
        case assignment
        case endBlock

        public var description: String {
            switch self {
            case .string(let str):
                return "\"\(str)\""
            case .boolean(let b):
                return "\(b)"
            case .uint(let ui):
                return "\(ui)"
            case .udouble(let ud):
                return "\(ud)"
            case .dash:
                return "'-'"
            case .assignment:
                return "'='"
            case .endBlock:
                return "end block"
            }
        }
    }

    public let location: SourceLocation
    public let value: Value

    public var description: String {
        return "\(self.value) at \(self.location)"
    }
}
