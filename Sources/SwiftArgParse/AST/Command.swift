//
//  CommandInfo.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/18/19.
//

public class Command {
    public var name: String
    public var subcommands = [String:Command]()

    public init(name: String) {
        self.name = name
    }

    public func add(subcommand: String) -> Command {
        let info = Command(name: subcommand)
        self.subcommands[subcommand] = info

        return info
    }

    public func contains(subcommand: String) -> Bool {
        return self.subcommands[subcommand] != nil
    }
}
