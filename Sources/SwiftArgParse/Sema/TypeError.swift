//
//  TypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/15/19.
//

public enum TypeError: Error {
    case inconsistant(name: String, expecting: Any.Type, found: Any.Type)
    case notFound(name: String)
}
