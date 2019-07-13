//
//  Token.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/7/19.
//

internal enum _Token: Equatable {
    case string(_ value: String)
    case number(_ value: Double)
    case boolean(_ value: Bool)
    case dash
    case assignment
}
