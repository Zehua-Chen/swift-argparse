//
//  Parameter.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/21/19.
//

public struct Parameter {
    public var name: String
    public var help: String
    public var type: Any.Type
    public var isRepeating: Bool

    public init<T>(
        name: String,
        type: T.Type,
        help: String = "",
        isRepeating: Bool = false
    ) {
        self.name = name
        self.type = type
        self.help = help
        self.isRepeating = isRepeating
    }
}
