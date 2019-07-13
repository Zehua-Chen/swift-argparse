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
internal enum _Token: Equatable {
    case string(_ value: String)
    case boolean(_ value: Bool)
    case uint(_ value: UInt)
    case udecimal(_ value: Double)
    case dash
    case assignment
}
