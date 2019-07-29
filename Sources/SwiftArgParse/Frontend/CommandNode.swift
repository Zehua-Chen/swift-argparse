//
//  CommandInfo.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/18/19.
//

internal class _CommandNode {
    internal var name: String
    internal var children = [String:_CommandNode]()

    internal var command: Command?
    internal var optionalParams: ASTContext.OptionalParamsType?

    internal init(name: String) {
        self.name = name
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
