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
        case pathNotFound
    }

    internal var _rootCommandNode: _CommandNode

    init(name: String) {
        _rootCommandNode = _CommandNode(name: name)
    }

    public mutating func add(
        path: [String],
        defaultOptionalParams: ASTContext.OptionalParamsType,
        closure: @escaping ClosureCommand.Closure
    ) throws {
        try self.add(
            path: path,
            command: ClosureCommand(closure: closure),
            defaultOptionalParams: defaultOptionalParams)
    }

    public mutating func add(
        path: [String],
        closure: @escaping ClosureCommand.Closure
    ) throws {
        try self.add(
            path: path,
            command: ClosureCommand(closure: closure),
            defaultOptionalParams: nil)
    }

    public mutating func add<C: Command>(
        path: [String],
        command: C,
        defaultOptionalParams: ASTContext.OptionalParamsType? = nil
    ) throws {
        let subroot = try _complete(path: path)

        // Don't want to temper with the node cursor if it is not moved
        subroot.command = command
        subroot.optionalParams = defaultOptionalParams
    }

    public func run(with args: [String] = CommandLine.arguments) throws {
        let context = try ASTContext(from: args, root: _rootCommandNode)
        let subroot = try _trace(path: context.subcommands)

        if subroot.command != nil {
            subroot.command!.run(with: context)
        }
    }

    fileprivate func _complete(path: [String]) throws -> _CommandNode {
        var subroot = _rootCommandNode
        var pathIterator = path.makeIterator()

        guard let rootPath = pathIterator.next() else {
            throw SubcommandError.pathEmpty
        }

        guard rootPath == _rootCommandNode.name else {
            throw SubcommandError.incorrectRootName
        }

        while let p = pathIterator.next() {
            if subroot.contains(subcommand: p) {
                subroot = subroot.children[p]!
            } else {
                subroot = subroot.add(subcommand: p)
            }
        }

        return subroot
    }

    fileprivate func _trace(path: [String]) throws -> _CommandNode {
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
                throw SubcommandError.pathNotFound
            } else {
                subroot = subroot.children[p]!
            }
        }

        return subroot
    }
}
