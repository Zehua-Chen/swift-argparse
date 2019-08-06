//
//  CommandLineApplication.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

import Foundation

public struct CommandLineApplication {

    public enum SubcommandError: Error {
        case incorrectRootName
        case pathEmpty
        case pathNotFound
    }

    internal var _rootCommandNode: _CommandNode

    public init(name: String) {
        _rootCommandNode = _CommandNode(name: name)
    }

    @discardableResult
    public mutating func add(path: [String]) throws -> Path {
        let terminal = try _complete(path: path)

        return Path(node: terminal)
    }

    @discardableResult
    public mutating func add(
        path: [String],
        executor: @escaping ClosureExecutor.Closure
    ) throws -> Path {
        var command = try! self.add(path: path)
        command.executor = ClosureExecutor(executor: executor)

        return command
    }

    public func parseContext(with args: [String] = CommandLine.arguments) throws -> ASTContext {
        let context = try ASTContext(from: args, root: _rootCommandNode)
        
        return context
    }

    public func run(with args: [String] = CommandLine.arguments) throws {
        var rawArgs = args
        rawArgs[0] = _lastComponent(rawArgs[0])

        var context = try ASTContext(from: rawArgs, root: _rootCommandNode)
        let subroot = try _trace(path: context.subcommands)

        guard let terminal = subroot as? _TerminalCommandNode else { return }

        for stage in terminal.semanticStages {
            if case .failure(let err) = stage(context) {
                throw err
            }
        }

        if terminal.executor != nil {
            if let subrootOptionalParams = terminal.defaultOptionalParams {
                context.optionalParams.merge(subrootOptionalParams, uniquingKeysWith: {
                    (a, b) in return a
                })
            }

            terminal.executor!.run(with: context)
        }
    }

    fileprivate mutating func _complete(path: [String]) throws -> _TerminalCommandNode {
        var subroot = _rootCommandNode
        var parent: _CommandNode? = nil
        var pathIterator = path.makeIterator()

        guard let rootPath = pathIterator.next() else {
            throw SubcommandError.pathEmpty
        }

        guard rootPath == _rootCommandNode.name else {
            throw SubcommandError.incorrectRootName
        }

        while let p = pathIterator.next() {
            parent = subroot

            if subroot.contains(subcommand: p) {
                subroot = subroot.children[p]!
            } else {
                subroot = subroot.add(subcommand: p)
            }
        }

        let terminal = _TerminalCommandNode(from: subroot)
        parent?.children[subroot.name] = terminal

        if subroot === _rootCommandNode {
            _rootCommandNode = terminal
        }

        return terminal
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

    fileprivate func _lastComponent(_ str: String) -> String {
        let uri = URL(fileURLWithPath: str)

        return uri.lastPathComponent
    }
}
