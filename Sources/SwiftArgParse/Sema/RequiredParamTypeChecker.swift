//
//  RequiredParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/24/19.
//

public enum RequiredParamTypeCheckerError: Error {
    case inconsistant(index: Int, expecting: Any.Type, found: Any.Type)
    case overflow(index: Int)
}

public struct RequiredParamTypeChecker {

    public enum RequiredParam {
        case recurrsing(type: Any.Type)
        case single(type: Any.Type)
    }

    /// Type information
    var typeInfo: [RequiredParam]

    /// Check a given ast context
    ///
    /// - Parameter context: the context to check
    /// - Returns: .success(()) if no type errors, otherwise, return
    /// .failure(RequiredParamTypeCheckerError)
    public func check(context: ASTContext) -> Result<(), RequiredParamTypeCheckerError> {
        var requiredParamIter = context.requiredParams.makeIterator()
        var requiredParamIndex = 0
        var typeInfoIter = self.typeInfo.makeIterator()
        var typeInfo = typeInfoIter.next()

        while let requiredParam = requiredParamIter.next() {
            guard typeInfo != nil else {
                return .failure(.overflow(index: requiredParamIndex))
            }

            let requiredParamType = type(of: requiredParam)

            switch typeInfo! {
            case .recurrsing(let expectedType):
                if requiredParamType != expectedType {
                    typeInfo = typeInfoIter.next()

                    guard typeInfo != nil else {
                        return .failure(.inconsistant(index: requiredParamIndex, expecting: expectedType, found: requiredParamType))
                    }

                    switch typeInfo! {
                    case .recurrsing(let futureExpectedType):
                        if futureExpectedType != requiredParamType {
                            return .failure(.inconsistant(index: requiredParamIndex, expecting: expectedType, found: requiredParamType))
                        }
                    case .single(let futureExpectedType):
                        if futureExpectedType != requiredParamType {
                            return .failure(.inconsistant(index: requiredParamIndex, expecting: expectedType, found: requiredParamType))
                        }

                        typeInfo = typeInfoIter.next()
                    }
                }

            case .single(let expectedType):
                if requiredParamType != expectedType {
                    return .failure(.inconsistant(index: requiredParamIndex, expecting: expectedType, found: requiredParamType))
                }
                
                typeInfo = typeInfoIter.next()
            }

            requiredParamIndex += 1
        }

        return .success(())
    }
}