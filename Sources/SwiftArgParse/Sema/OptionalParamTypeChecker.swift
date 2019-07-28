//
//  OptionalParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/23/19.
//

public enum OptionalParamTypeCheckerError: Error {
    case inconsistant(name: String, expecting: Any.Type, found: Any.Type)
    case notFound(name: String)
}

public struct OptionalParamTypeChecker {

    /// Type information
    public var typeInfo: [String: Any.Type]

    /// Construct an optional param type checker using provided
    /// type information
    ///
    /// - Parameter typeInfo: the type information
    public init(typeInfo: [String: Any.Type]) {
        self.typeInfo = typeInfo
    }

    /// Check a given ast context
    ///
    /// - Parameter context: the context to check
    /// - Returns: .success(()) if no type errors, otherwise, return
    /// .failure(OptionalParamTypeCheckerError)
    public func check(context: ASTContext) -> Result<(), OptionalParamTypeCheckerError> {

        for item in self.typeInfo {
            guard let optionalParam = context.optionalParams[item.key] else {
                return .failure(.notFound(name: item.key))
            }

            let optionalParamT = type(of: optionalParam)

            if optionalParamT != item.value {
                return .failure(.inconsistant(name: item.key, expecting: item.value, found: optionalParamT))
            }
        }

        return .success(())
    }
}
