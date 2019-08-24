//
//  Configuration.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/21/19.
//

public class Configuration: CustomStringConvertible {
    internal var options: [String: Option] = [:]
    internal var optionAliases: [String: String] = [:]

    internal var parameters: [Parameter] = []
    internal var children: [String: Configuration] = [:]
    internal var command: Command?

    public var allowsUnregisteredOptions: Bool = false

    public var description: String {
        var help = ""

        help += "Subcommands:\n"

        for (command, _) in children {
            help += "\t\(command)\n"
        }

        // MARK: Print options
        help += "Options:\n"

        for (_, value) in options {
            help += "\t"

            if value.alias != nil {
                help += "\(value.alias!), "
            }

            help += "\(value.name)"
            help += "=\(value.defaultValue)"
            help += "\t\(value.help)\n"
        }

        // MARK: Print parameters
        help += "Parameters:\n"

        for parameter in parameters {
            help += "\t\(parameter.name)\t\(parameter.help)"
        }

        return help
    }

    init() {
        self.use(Option(name: "--help", defaultValue: false, alias: nil, help: "Get help"))
    }
    
    public func use(_ option: Option) {
        self.options[option.name] = option

        if let alias = option.alias {
            self.optionAliases[alias] = option.name
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
