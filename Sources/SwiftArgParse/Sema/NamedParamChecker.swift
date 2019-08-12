//
//  NamedParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/23/19.
//

public enum NamedParamCheckerError: Error, CustomStringConvertible {
    case inconsistant(name: String, expecting: Any.Type, found: Any.Type)

    public var description: String {
        switch self {
        case .inconsistant(let name, let expecting, let found):
            return "for param \(name), expecting \(expecting) but found \(found)"
        }
    }
}

public struct NamedParamChecker {

    /// Type information
    public var paramInfo = [String: Any.Type]()

    public init() {}

    /// Construct an named param type checker using provided
    /// type information
    ///
    /// - Parameter typeInfo: the type information
    public init(typeInfo: [String: Any.Type]) {
        self.paramInfo = typeInfo
    }

    /// Check a given ast context
    ///
    /// - Parameter context: the context to check
    /// - Returns: .success(()) if no type errors, otherwise, return
    /// .failure(NamedParamCheckerError)
    public func check(against context: ASTContext) throws {

        for item in self.paramInfo {
            guard let namedParam = context.namedParams[item.key] else {
                continue
            }

            let namedParamT = type(of: namedParam)

            if namedParamT != item.value {
                throw NamedParamCheckerError.inconsistant(name: item.key, expecting: item.value, found: namedParamT)
            }
        }
    }
}
