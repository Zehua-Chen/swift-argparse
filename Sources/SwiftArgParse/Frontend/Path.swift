//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/30/19.
//

public typealias SemanticStage = (_ context: ASTContext) -> Result<(), Error>

public struct Path {
    fileprivate var _node: _ExecutableCommandNode

    public var defaultNamedParams: [String: Any] {
        get { return _node.defaultNamedParams }
    }

    public var executor: Executor? {
        get { return _node.executor }
        set { _node.executor = newValue }
    }

    internal init(node: _ExecutableCommandNode) {
        _node = node
    }

    public func add<Param>(
        namedParam name: String,
        type: Param.Type
    ) {
        _node.namedParamChecker.paramInfo[name] = type
    }

    public func add<Param>(namedParam name: String, defaultValue: Param) {
        _node.namedParamChecker.paramInfo[name] = Param.self
        _node.defaultNamedParams[name] = defaultValue
    }
}
