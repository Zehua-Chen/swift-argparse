//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/30/19.
//

public typealias SemanticStage = (_ context: ASTContext) -> Result<(), Error>

public struct Path {
    fileprivate var _node: _ExecutableCommandNode

    public var defaultOptionalParams: [String: Any] {
        get { return _node.defaultOptionalParams }
    }

    public var executor: Executor? {
        get { return _node.executor }
        set { _node.executor = newValue }
    }

    internal init(node: _ExecutableCommandNode) {
        _node = node
    }

    public func add<Param>(
        optionalParam name: String,
        type: Param.Type
    ) {
        _node.optionalParamTypeChecker.paramInfo[name] = type
    }

    public func add<Param>(optionalParam name: String, defaultValue: Param) {
        _node.optionalParamTypeChecker.paramInfo[name] = Param.self
        _node.defaultOptionalParams[name] = defaultValue
    }
}
