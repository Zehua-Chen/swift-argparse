//
//  CommandContext.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/22/19.
//

@dynamicMemberLookup
public struct CommandContext {

    /// Options that the user input
    public var options: [String: Any] = [:]

    /// Parameters that the user input
    public var parameters: [Any] = []

    /// The prefix to use when looking up options by keypath
    public var commonOptionPrefix: String = "--"

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
        for option in config.options {
            if self.options[option.key] == nil {
                self.options[option.key] = option.value.defaultValue
            }
        }
    }

    public subscript(dynamicMember member: String) -> Any? {
        return self.options["\(self.commonOptionPrefix)\(member)"]
    }

    public subscript(paramIndex: Int) -> Any {
        return self.parameters[paramIndex]
    }
}
