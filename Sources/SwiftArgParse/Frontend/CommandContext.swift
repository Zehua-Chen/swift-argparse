//
//  CommandContext.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/22/19.
//

public struct CommandContext {
    public var options: [String: Any] = [:]
    public var parameters: [Any] = []

    internal init(astContext: _ASTContext, config: Configuration) {
        let elements = astContext.elements.lazy
            .compactMap({ return $0 })
            .filter({ element in
                if case .path(_) = element {
                    return false
                }

                return true
            })

        for element in elements {
            switch element {
            case .primitive(let primitive):
                self.parameters.append(primitive.value)
            case .option(let option):
                self.options[option.name] = option.value!
            default:
                fatalError("Somehow elements other than element and path are not filtered out")
            }
        }

        // Apply default values
        for optionDefault in config.optionDefaults {
            if self.options[optionDefault.key] == nil {
                self.options[optionDefault.key] = optionDefault.value
            }
        }
    }
}
