//
//  Option.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/21/19.
//

public struct Option {
    public var name: String
    public var help: String
    public var type: Any.Type

    public var alias: String?
    public var defaultValue: Any?

    public init(
        name: String,
        type: Any.Type,
        help: String = "",
        alias: String? = nil
    ) {
        self.name = name
        self.help = help
        self.type = type
        self.alias = alias
    }

    @inlinable
    public init<T>(
        name: String,
        defaultValue: T,
        help: String = "",
        alias: String? = nil
    ) {
        self.name = name
        self.defaultValue = defaultValue
        self.help = help
        self.type = T.self
        self.alias = alias
    }
}
