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

    /// The name of the command line application
    public var name: String {
        return _rootCommandNode.name
    }

    /// Create a command line application using a name
    ///
    /// - Parameter name: name of the command line application
    public init(name: String) {
        _rootCommandNode = _CommandNode(name: name)
    }

    /// Add a path to a command line application
    ///
    /// - Parameter path: the path
    /// - Returns: a handle to the added path
    /// - Throws: SubcommandError
    @discardableResult
    public mutating func addPath(_ path: [String]) throws -> Path {
        let terminal = try _completePath(path)

        return Path(node: terminal)
    }

    /// Add a path
    ///
    /// - Parameters:
    ///   - path: the path
    ///   - executor: the executor to be associated with the path
    /// - Returns: a handle to the added path
    /// - Throws: SubcommandError
    @discardableResult
    public mutating func addPath(
        _ path: [String],
        executor: @escaping ClosureExecutor.Closure
    ) throws -> Path {
        var command = try! self.addPath(path)
        command.executor = ClosureExecutor(executor: executor)

        return command
    }

    /// Parse an ASTContext
    ///
    /// - Parameter args: command line arguments
    /// - Returns: a parsed ASTContext
    /// - Throws: any error associated with parsing
    public func parseContext(with args: [String] = CommandLine.arguments) throws -> ASTContext {
        var rawArgs = args
        rawArgs[0] = _lastComponent(of: rawArgs[0])

        let context = try ASTContext(args: rawArgs, root: _rootCommandNode)
        
        return context
    }

    /// Run the application with the given command line arguments
    ///
    /// - Parameter args: the command line arguments to use
    /// - Throws: any error
    public func run(with args: [String] = CommandLine.arguments) throws {
        var context = try parseContext(with: args)
        let subroot = try _tracePath(context.subcommands)

        guard let terminal = subroot as? _ExecutableCommandNode else {
            throw SubcommandError.pathNotExecutable(context.subcommands)
        }

        context.namedParams.merge(terminal.defaultNamedParams, uniquingKeysWith: {
            (a, b) in return a
        })

        for stage in terminal.semanticStages {
            try stage(context)
        }

        if terminal.executor != nil {
            terminal.executor!.run(with: context)
        }
    }

    /// Complete a path
    ///
    /// - Parameter path: the path
    /// - Returns: the executable command node inserted during completion
    /// - Throws: SubcommandError
    fileprivate mutating func _completePath(_ path: [String]) throws -> _ExecutableCommandNode {
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

            if subroot.containsSubcommand(p) {
                subroot = subroot.children[p]!
            } else {
                subroot = subroot.addSubcommand(p)
            }
        }

        let terminal = _ExecutableCommandNode(from: subroot)
        parent?.children[subroot.name] = terminal

        if subroot === _rootCommandNode {
            _rootCommandNode = terminal
        }

        return terminal
    }

    /// Trace a given path
    ///
    /// - Parameter path: a path
    /// - Returns: the command node at the end of the path
    /// - Throws: SubcommandError
    fileprivate func _tracePath(_ path: [String]) throws -> _CommandNode {
        var subroot = _rootCommandNode

        guard !path.isEmpty else {
            throw SubcommandError.pathEmpty
        }

        guard _rootCommandNode.name == path[0] else {
            throw SubcommandError.incorrectRootName
        }

        for p in path[1...] {
            if subroot.containsSubcommand(p) {
                subroot = subroot.children[p]!
            } else {
                throw SubcommandError.pathNotFound(path)
            }
        }

        return subroot
    }

    /// Get the last component of a file path
    ///
    /// - Parameter str: a file path
    /// - Returns: the last componet of the inputed file path string
    fileprivate func _lastComponent(of str: String) -> String {
        let uri = URL(fileURLWithPath: str)

        return uri.lastPathComponent
    }
}
