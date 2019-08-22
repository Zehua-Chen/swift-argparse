//
//  Configuration.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/21/19.
//

public class Configuration {
    internal var options: [String: Option] = [:]
    internal var optionAliases: [String: String] = [:]
    internal var optionDefaults: [String: Any] = [:]

    internal var parameters: [Parameter] = []
    internal var children: [String: Configuration] = [:]
    internal var command: Command?

    public var allowsUnregisteredOptions: Bool = false
    
    public func use(_ option: Option) {
        self.options[option.name] = option

        if let alias = option.alias {
            optionAliases[alias] = option.name
        }

        if option.defaultValue != nil {
            optionDefaults[option.name] = option.defaultValue!
        }
    }

    public func use(_ parameter: Parameter) {
        self.parameters.append(parameter)
    }

    public func use(_ command: Command, for name: String) {
        let config = self.makeChildren(name: name)
        config.command = command
        command.setup(with: config)
    }

    internal func makeChildren(name: String) -> Configuration {
        let c = Configuration()
        self.children[name] = c

        return c
    }
}
