//
//  UnnamedParamTypeChecker.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/24/19.
//

public enum ParameterError: Error {
    case typeMismatch(index: Int, expecting: Any.Type, found: Any.Type, location: SourceLocation)
    case tooManyParameters
    case notEnoughParameters
    case unrecognized(index: Int, location: SourceLocation)
}

internal struct _ParameterChecker {

    internal func run(on context: _ASTContext, with config: Configuration) throws {
        let elements = context.elements.lazy
            .enumerated()
            .compactMap({ (offset, element) -> (offset: Int, element: _ASTContext.Element)? in
                if element == nil {
                    return nil
                }

                return (offset, element!)
            })

        var elementIndex = 0
        var paramConfigIndex = 0
        let paramConfigs = config.parameters

        while elementIndex < elements.count && paramConfigIndex < paramConfigs.count {
            let element = elements[elementIndex]

            guard case .primitive(let primitive) = element.element else {
                elementIndex += 1
                continue
            }

            let actualType = type(of: primitive.value)
            let paramConfig = paramConfigs[paramConfigIndex]

            if actualType == paramConfig.type {
                elementIndex += 1

                if !paramConfigs[paramConfigIndex].isRepeating {
                    paramConfigIndex += 1
                }

                continue
            }

            if !paramConfig.isRepeating {
                throw ParameterError.typeMismatch(
                    index: element.offset,
                    expecting: paramConfig.type,
                    found: actualType,
                    location: primitive.location)
            }

            paramConfigIndex += 1
        }

        if paramConfigIndex != paramConfigs.count {
            throw ParameterError.notEnoughParameters
        }

        if elementIndex != elements.count {
            throw ParameterError.tooManyParameters
        }
    }
}
