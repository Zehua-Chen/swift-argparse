//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/30/19.
//

public typealias SemanticStage = (_ context: ASTContext) -> Result<(), Error>

public struct Path {
    @usableFromInline
    internal var _node: _ExecutableCommandNode

    public var defaultNamedParams: [String: Any] {
        get { return _node.defaultNamedParams }
    }

    public var checksNamedParams: Bool {
        get { return _node.checksNamedParams }
        set { _node.checksNamedParams = newValue }
    }

    public var checksUnnamedParams: Bool {
        get { return _node.checksUnnamedParams }
        set { _node.checksUnnamedParams = newValue }
    }

    public var executor: Executor? {
        get { return _node.executor }
        set { _node.executor = newValue }
    }

    internal init(node: _ExecutableCommandNode) {
        _node = node
    }

    @inlinable
    public func add<Param>(
        namedParam name: String,
        type: Param.Type
    ) {
        _node.namedParamChecker.paramInfo[name] = type
    }

    @inlinable
    public func add<Param>(namedParam name: String, defaultValue: Param) {
        _node.namedParamChecker.paramInfo[name] = Param.self
        _node.defaultNamedParams[name] = defaultValue
    }

    @inlinable
    public func add<Param>(unnamedParam: Param.Type, isRecurring: Bool = false) {
        if isRecurring {
            _node.unnamedParamChecker.paramInfo.append(.recurring(type: unnamedParam))
        } else {
            _node.unnamedParamChecker.paramInfo.append(.single(type: unnamedParam))
        }
    }

    public func add(customSemanticStage: @escaping SemanticStage) {
        _node.customSemanticStage.append(customSemanticStage)
    }
}
