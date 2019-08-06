//
//  CommandInfo.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/18/19.
//

internal class _CommandNode {
    internal var name: String
    internal var children: [String:_CommandNode]

    internal init(name: String, children: [String:_CommandNode] = [:]) {
        self.name = name
        self.children = children
    }

    internal func add(subcommand: String) -> _CommandNode {
        let node = _CommandNode(name: subcommand)
        self.children[subcommand] = node

        return node
    }

    internal func contains(subcommand: String) -> Bool {
        return self.children[subcommand] != nil
    }
}
