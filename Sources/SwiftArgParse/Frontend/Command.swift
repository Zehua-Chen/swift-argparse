//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/30/19.
//

public struct Command {
    fileprivate var _node: _CommandNode

    public var defaultOptionalParams: ASTContext.OptionalParamsType? {
        get { return _node.defaultOptionalParams }
        set { _node.defaultOptionalParams = newValue }
    }

    public var executor: Executor? {
        get { return _node.executor }
        set { _node.executor = newValue }
    }

    internal init(node: _CommandNode) {
        _node = node
    }

}
