//
//  Configuration.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/21/19.
//

public class Configuration {
    internal var options: [String: Option] = [:]
    fileprivate var _optionAliases: [String: String] = [:]
    fileprivate var _parameters: [Parameter] = []
    internal var children: [String: Configuration] = [:]
    internal var command: Command?

    public var allowsUnregisteredOptions: Bool = false
    
    public func use(_ option: Option) {
        self.options[option.name] = option

        if let alias = option.alias {
            _optionAliases[alias] = option.name
        }
    }

    public func use(_ parameter: Parameter) {
        _parameters.append(parameter)
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
