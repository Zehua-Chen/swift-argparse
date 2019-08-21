//
//  AST.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/13/19.
//

internal struct _ASTContext {

    internal struct Path: Equatable {
        public var value: String
        public var location: SourceLocation
    }

    internal struct Primitive: Equatable {
        public var value: Any
        public var location: SourceLocation

        internal static func ==(lhs: Primitive, rhs: Primitive) -> Bool {
            return lhs.location == rhs.location
        }
    }

    internal struct Option: Equatable {
        public var name: String
        public var value: Any?
        public var location: SourceLocation

        internal static func ==(lhs: Option, rhs: Option) -> Bool {
            return lhs.name == rhs.name && lhs.location == rhs.location
        }
    }

    internal enum Element: Equatable {
        case path(_ path: Path)
        case primitive(_ primitive: Primitive)
        case option(_ option: Option)
    }

    internal var elements: [Element?] = []

    internal init(args: ArraySlice<String>) throws {
        var parser = _Parser(args: args)
        try parser.parse(into: &self)
    }

    internal mutating func append(_ primitive: Primitive) {
        self.elements.append(.primitive(primitive))
    }

    internal mutating func append(_ option: Option) {
        self.elements.append(.option(option))
    }
}

internal extension _ASTContext.Element {
    var location: SourceLocation {
        switch self {
        case .option(let o):
            return o.location
        case .primitive(let p):
            return p.location
        case .path(let p):
            return p.location
        }
    }

    func asPrimitive() -> _ASTContext.Primitive {
        guard case .primitive(let p) = self else {
            fatalError()
        }

        return p
    }

    func asOption() -> _ASTContext.Option {
        guard case .option(let o) = self else {
            fatalError()
        }

        return o
    }
}
