//
//  OptionalParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/23/19.
//

public struct OptionalParamTypeChecker {

    public var typeInfo: [String: Any.Type]

    public init(typeInfo: [String: Any.Type]) {
        self.typeInfo = typeInfo
    }

    public func check(context: ASTContext) -> Result<(), TypeError> {

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
