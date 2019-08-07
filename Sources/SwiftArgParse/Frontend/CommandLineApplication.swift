//
//  CommandLineApplication.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

import Foundation

public struct CommandLineApplication {

    public enum SubcommandError: Error, CustomStringConvertible {
        case incorrectRootName
        case pathEmpty
        case pathNotFound(_ path: [String])
        case pathNotExecutable(_ path: [String])

        public var description: String {
            switch self {
            case .incorrectRootName:
                return "In correct root name"
            case .pathEmpty:
                return "Path empty"
            case .pathNotFound(let path):
                return "\(path) not found"
            case .pathNotExecutable(let path):
                return "\(path) is not executable"
            }
        }
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
        var rawArgs = args
        rawArgs[0] = _lastComponent(rawArgs[0])

        let context = try ASTContext(from: rawArgs, root: _rootCommandNode)
        
        return context
    }

    public func run(with args: [String] = CommandLine.arguments) throws {
        var context = try parseContext(with: args)
        let subroot = try _trace(path: context.subcommands)

        guard let terminal = subroot as? _ExecutableCommandNode else {
            throw SubcommandError.pathNotExecutable(context.subcommands)
        }

        context.namedParams.merge(terminal.defaultNamedParams, uniquingKeysWith: {
            (a, b) in return a
        })

        for stage in terminal.semanticStages {
            if case .failure(let err) = stage(context) {
                throw err
            }
        }

        if terminal.executor != nil {
            terminal.executor!.run(with: context)
        }
    }

    fileprivate mutating func _complete(path: [String]) throws -> _ExecutableCommandNode {
        var subroot = _rootCommandNode
        var parent: _CommandNode? = nil

        guard !path.isEmpty else {
            throw SubcommandError.pathEmpty
        }

        guard _rootCommandNode.name == path[0] else {
            throw SubcommandError.incorrectRootName
        }

        for p in path[1...] {
            parent = subroot

            if subroot.contains(subcommand: p) {
                subroot = subroot.children[p]!
            } else {
                subroot = subroot.add(subcommand: p)
            }
        }

        let terminal = _ExecutableCommandNode(from: subroot)
        parent?.children[subroot.name] = terminal

        if subroot === _rootCommandNode {
            _rootCommandNode = terminal
        }

        return terminal
    }

    fileprivate func _trace(path: [String]) throws -> _CommandNode {
        var subroot = _rootCommandNode

        guard !path.isEmpty else {
            throw SubcommandError.pathEmpty
        }

        guard _rootCommandNode.name == path[0] else {
            throw SubcommandError.incorrectRootName
        }

        for p in path[1...] {
            if subroot.contains(subcommand: p) {
                subroot = subroot.children[p]!
            } else {
                throw SubcommandError.pathNotFound(path)
            }
        }

        return subroot
    }

    fileprivate func _lastComponent(_ str: String) -> String {
        let uri = URL(fileURLWithPath: str)

        return uri.lastPathComponent
    }
}
