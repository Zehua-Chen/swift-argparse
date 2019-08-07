//
//  Token.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/7/19.
//

/// Token generaged by the Lexer
///
/// - string: string
/// - boolean: boolean
/// - uint: unsigned integer
/// - udecimal: unsigned decimal
/// - dash: dash `-`
/// - assignment: assignment `=`
public enum Token: Equatable, CustomStringConvertible {
    case string(_ value: String)
    case boolean(_ value: Bool)
    case uint(_ value: UInt)
    case udecimal(_ value: Double)
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
        case .udecimal(let ud):
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
