//
//  CommandInfo.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/18/19.
//


/// Command nodes form a tree structure of subcommands 
@usableFromInline
internal class _CommandNode {
    internal var name: String
    internal var children: [String:_CommandNode]

    /// Create a command node
    ///
    /// - Parameters:
    ///   - name: name of the command nodes
    ///   - children: children of the command node
    internal init(name: String, children: [String:_CommandNode] = [:]) {
        self.name = name
        self.children = children
    }

    /// Add a subcommand with the given name
    ///
    /// - Parameter subcommand: the name of the subcommand
    /// - Returns: a created subcommand
    internal func addSubcommand(_ subcommand: String) -> _CommandNode {
        let node = _CommandNode(name: subcommand)
        self.children[subcommand] = node

        return node
    }

    /// Determine if the current node has a child with the specified name
    ///
    /// - Parameter subcommand: the name of the children to lookup
    /// - Returns: if there is such as children
    internal func containsSubcommand(_ subcommand: String) -> Bool {
        return self.children[subcommand] != nil
    }
}
