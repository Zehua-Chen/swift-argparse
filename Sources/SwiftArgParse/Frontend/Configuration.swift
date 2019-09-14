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

        // MARK: Print subcommands
        var masterDetailView = _MasterDetailView(title: "Subcommands")

        for (command, _) in children {
            masterDetailView.append(.init(master: command, detail: ""))
        }

        masterDetailView.print(to: &help)
        masterDetailView.removeAll()

        // MARK: Print options
        masterDetailView.title = "Options"

        for (_, value) in options {
            var optionName = ""

            if value.alias != nil {
                print(value.alias!, separator: "", terminator: ",", to: &optionName)
            }

            print(value.name, separator: "", terminator: "", to: &optionName)

            masterDetailView.append(.init(master: optionName, detail: value.help))
        }

        masterDetailView.print(to: &help)
        masterDetailView.removeAll()

        masterDetailView.title = "Parameters"

        for parameter in parameters {
            masterDetailView.append(.init(master: parameter.name, detail: parameter.help))
        }

        masterDetailView.print(to: &help)

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
