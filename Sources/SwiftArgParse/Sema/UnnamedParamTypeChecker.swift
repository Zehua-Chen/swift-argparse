//
//  UnnamedParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/24/19.
//

public enum UnnamedParamTypeCheckerError: Error {
    case inconsistant(index: Int, expecting: Any.Type, found: Any.Type)
    case overflow(index: Int)
}

public struct UnnamedParamTypeChecker {

    public enum UnnamedParam {
        case recurrsing(type: Any.Type)
        case single(type: Any.Type)
    }

    /// Type information
    var typeInfo: [UnnamedParam]

    /// Check a given ast context
    ///
    /// - Parameter context: the context to check
    /// - Returns: .success(()) if no type errors, otherwise, return
    /// .failure(UnnamedParamTypeCheckerError)
    public func check(context: ASTContext) -> Result<(), UnnamedParamTypeCheckerError> {
        var unnamedParamIter = context.unnamedParams.makeIterator()
        var unnamedParamIndex = 0
        var typeInfoIter = self.typeInfo.makeIterator()
        var typeInfo = typeInfoIter.next()

        while let unnamedParam = unnamedParamIter.next() {
            guard typeInfo != nil else {
                return .failure(.overflow(index: unnamedParamIndex))
            }

            let unnamedParamType = type(of: unnamedParam)

            switch typeInfo! {
            case .recurrsing(let expectedType):
                if unnamedParamType != expectedType {
                    typeInfo = typeInfoIter.next()

                    guard typeInfo != nil else {
                        return .failure(.inconsistant(index: unnamedParamIndex, expecting: expectedType, found: unnamedParamType))
                    }

                    switch typeInfo! {
                    case .recurrsing(let futureExpectedType):
                        if futureExpectedType != unnamedParamType {
                            return .failure(.inconsistant(index: unnamedParamIndex, expecting: expectedType, found: unnamedParamType))
                        }
                    case .single(let futureExpectedType):
                        if futureExpectedType != unnamedParamType {
                            return .failure(.inconsistant(index: unnamedParamIndex, expecting: expectedType, found: unnamedParamType))
                        }

                        typeInfo = typeInfoIter.next()
                    }
                }

            case .single(let expectedType):
                if unnamedParamType != expectedType {
                    return .failure(.inconsistant(index: unnamedParamIndex, expecting: expectedType, found: unnamedParamType))
                }
                
                typeInfo = typeInfoIter.next()
            }

            unnamedParamIndex += 1
        }

        return .success(())
    }
}
