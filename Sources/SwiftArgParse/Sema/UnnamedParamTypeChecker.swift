//
//  UnnamedParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/24/19.
//

public enum UnnamedParamTypeCheckerError: Error, CustomStringConvertible {
    case inconsistant(index: Int, expecting: Any.Type, found: Any.Type)
    case overflow(index: Int)

    public var description: String {
        switch self {
        case .inconsistant(let index, let expecting, let found):
            return "index = \(index), expecting \(expecting), found \(found)"
        case .overflow(let index):
            return "overflow at index \(index)"
        }
    }
}

public struct UnnamedParamTypeChecker {

    public enum UnnamedParam {
        case recurring(type: Any.Type)
        case single(type: Any.Type)
    }

    /// Type information
    public var paramInfo = [UnnamedParam]()

    /// Check a given ast context
    ///
    /// - Parameter context: the context to check
    /// - Returns: .success(()) if no type errors, otherwise, return
    /// .failure(UnnamedParamTypeCheckerError)
    public func check(against context: ASTContext) throws {
        var unnamedParamIter = context.unnamedParams.makeIterator()
        var unnamedParamIndex = 0
        var paramInfoIter = self.paramInfo.makeIterator()
        var paramInfo = paramInfoIter.next()

        while paramInfo != nil {

            guard let unnamedParam = unnamedParamIter.next() else {
                if case .recurring(_) = paramInfo! {
                    return
                }
                
                throw UnnamedParamTypeCheckerError.overflow(index: unnamedParamIndex)
            }

            let unnamedParamT = type(of: unnamedParam)

            switch paramInfo! {
            case .single(let type):
                if type != unnamedParamT {
                    throw UnnamedParamTypeCheckerError.inconsistant(
                        index: unnamedParamIndex,
                        expecting: type,
                        found: unnamedParamT)
                }

                paramInfo = paramInfoIter.next()
            case .recurring(let type):
                if type != unnamedParamT {
                    paramInfo = paramInfoIter.next()

                    guard paramInfo != nil else {
                        throw UnnamedParamTypeCheckerError.inconsistant(
                            index: unnamedParamIndex,
                            expecting: type,
                            found: unnamedParamT)
                    }

                    switch paramInfo! {
                    case .single(let nextType):
                        if nextType != unnamedParamT {
                            throw UnnamedParamTypeCheckerError.inconsistant(
                                index: unnamedParamIndex,
                                expecting: type,
                                found: unnamedParamT)
                        }

                        paramInfo = paramInfoIter.next()
                    case .recurring(let nextType):
                        if nextType != unnamedParamT {
                            throw UnnamedParamTypeCheckerError.inconsistant(
                                index: unnamedParamIndex,
                                expecting: nextType,
                                found: unnamedParamT)
                        }
                    }
                }
            }

            unnamedParamIndex += 1
        }

        if let _ = unnamedParamIter.next() {
            throw UnnamedParamTypeCheckerError.overflow(index: unnamedParamIndex)
        }
    }
}
