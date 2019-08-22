//
//  UnnamedParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/24/19.
//

public enum ParameterError: Error {
    case typeMismatch(index: Int, expecting: Any.Type, found: Any.Type, location: SourceLocation)
    case overflow(index: Int, location: SourceLocation)
}

internal struct _ParameterChecker {

    internal func run(on context: _ASTContext, with config: Configuration) throws {
        let elements = context.elements.lazy
            .compactMap({ return $0 })

        var paramConfigIndex = 0
        var paramIndex = -1

        for case .primitive(let primitive) in elements {
            paramIndex += 1
            
            let paramConfig = config.parameters[paramConfigIndex]
            let actualType = type(of: primitive.value)

            if actualType == paramConfig.type {
                if !paramConfig.isRepeating {
                    paramConfigIndex += 1
                }

                continue
            }

            // Handle type mismatch
            if !paramConfig.isRepeating {
                throw ParameterError.typeMismatch(
                    index: paramIndex,
                    expecting: paramConfig.type,
                    found: actualType,
                    location: primitive.location)
            }

            if paramConfigIndex + 1 >= config.parameters.count {
                throw ParameterError.overflow(index: paramIndex, location: primitive.location)
            }

            let nextConfig = config.parameters[paramConfigIndex + 1]

            if actualType != nextConfig.type {
                throw ParameterError.typeMismatch(
                    index: paramIndex,
                    expecting: nextConfig.type,
                    found: actualType,
                    location: primitive.location)
            }

            paramConfigIndex += 1
        }
    }

    /// Check a given ast context
    ///
    /// - Parameter context: the context to check
    /// - Returns: .success(()) if no type errors, otherwise, return
    /// .failure(UnnamedParamTypeCheckerError)
//    public func check(against context: ASTContext) throws {
//        var unnamedParamIter = context.unnamedParams.makeIterator()
//        var unnamedParamIndex = 0
//        var paramInfoIter = self.paramInfo.makeIterator()
//        var paramInfo = paramInfoIter.next()
//
//        while paramInfo != nil {
//
//            guard let unnamedParam = unnamedParamIter.next() else {
//                if case .recurring(_) = paramInfo! {
//                    return
//                }
//
//                throw UnnamedParamTypeCheckerError.overflow(index: unnamedParamIndex)
//            }
//
//            let unnamedParamT = type(of: unnamedParam)
//
//            switch paramInfo! {
//            case .single(let type):
//                if type != unnamedParamT {
//                    throw UnnamedParamTypeCheckerError.inconsistant(
//                        index: unnamedParamIndex,
//                        expecting: type,
//                        found: unnamedParamT)
//                }
//
//                paramInfo = paramInfoIter.next()
//            case .recurring(let type):
//                if type != unnamedParamT {
//                    paramInfo = paramInfoIter.next()
//
//                    guard paramInfo != nil else {
//                        throw UnnamedParamTypeCheckerError.inconsistant(
//                            index: unnamedParamIndex,
//                            expecting: type,
//                            found: unnamedParamT)
//                    }
//
//                    switch paramInfo! {
//                    case .single(let nextType):
//                        if nextType != unnamedParamT {
//                            throw UnnamedParamTypeCheckerError.inconsistant(
//                                index: unnamedParamIndex,
//                                expecting: type,
//                                found: unnamedParamT)
//                        }
//
//                        paramInfo = paramInfoIter.next()
//                    case .recurring(let nextType):
//                        if nextType != unnamedParamT {
//                            throw UnnamedParamTypeCheckerError.inconsistant(
//                                index: unnamedParamIndex,
//                                expecting: nextType,
//                                found: unnamedParamT)
//                        }
//                    }
//                }
//            }
//
//            unnamedParamIndex += 1
//        }
//
//        if let _ = unnamedParamIter.next() {
//            throw UnnamedParamTypeCheckerError.overflow(index: unnamedParamIndex)
//        }
//    }
}
