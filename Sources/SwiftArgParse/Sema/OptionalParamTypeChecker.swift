//
//  OptionalParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/23/19.
//

public struct OptionalParamTypeChecker {

    public var typeInfo: [String: ParamType]

    public init(typeInfo: [String: ParamType]) {
        self.typeInfo = typeInfo
    }

    public func check(context: ASTContext) -> Result<(), TypeError> {

        for item in self.typeInfo {
            guard let optionalParam = context.optionalParams[item.key] else {
                return .failure(.notFound(name: item.key))
            }

            if !optionalParam.is(type: item.value) {
                return .failure(.inconsistant(name: item.key, expecting: item.value, found: optionalParam.type))
            }
        }

        return .success(())
    }
}
