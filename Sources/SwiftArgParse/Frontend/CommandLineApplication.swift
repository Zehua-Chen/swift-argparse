//
//  CommandLineApplication.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

public struct CommandLineApplication {

    public enum SubcommandError: Error {
        case incorrectRootName
        case pathEmpty
    }

    internal var _rootCommandNode: _CommandNode

    init(name: String) {
        _rootCommandNode = _CommandNode(name: name)
    }

    public mutating func add<C: Command>(command: C, path: [String]) throws {
        var subroot = _rootCommandNode
        var pathIterator = path.makeIterator()

        guard let rootPath = pathIterator.next() else {
            throw SubcommandError.pathEmpty
        }

        guard rootPath == _rootCommandNode.name else {
            throw SubcommandError.incorrectRootName
        }

        while let p = pathIterator.next() {
            if !subroot.contains(subcommand: p) {
                subroot = subroot.add(subcommand: p)
            }
        }

        // Don't want to temper with the node cursor if it is not moved
        if subroot !== _rootCommandNode {
            subroot.command = command
        }
    }
}
