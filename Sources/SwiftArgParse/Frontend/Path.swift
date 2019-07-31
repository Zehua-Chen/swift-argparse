//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/30/19.
//

public typealias SemanticStage = (_ context: ASTContext) -> Result<(), Error>

public struct Path {
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

    func add(semanticStage: @escaping SemanticStage) {
        _node.semanticStages.append(semanticStage)
    }
}
