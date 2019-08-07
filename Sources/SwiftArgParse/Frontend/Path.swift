//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/30/19.
//

public typealias SemanticStage = (_ context: ASTContext) -> Result<(), Error>

/// A path in the command line application
public struct Path {
    @usableFromInline
    internal var _node: _ExecutableCommandNode

    /// Return a dictionary that contains the default named parameters
    public var defaultNamedParams: [String: Any] {
        get { return _node.defaultNamedParams }
    }

    /// Whether to run checks for named parameters
    public var checksNamedParams: Bool {
        get { return _node.checksNamedParams }
        set { _node.checksNamedParams = newValue }
    }

    /// Whether to run checks for unnamed parmaeters
    public var checksUnnamedParams: Bool {
        get { return _node.checksUnnamedParams }
        set { _node.checksUnnamedParams = newValue }
    }

    /// The function executor of this path
    public var executor: Executor? {
        get { return _node.executor }
        set { _node.executor = newValue }
    }

    /// Create a new node from a executale command node
    ///
    /// - Parameter node: the executable command node
    internal init(node: _ExecutableCommandNode) {
        _node = node
    }

    /// Add a named param
    ///
    /// - Parameters:
    ///   - name: the name of the param
    ///   - type: the type of the param
    @inlinable
    public func registerNamedParam<Param>(
        _ name: String,
        type: Param.Type
    ) {
        _node.namedParamChecker.paramInfo[name] = type
    }

    /// Add a named param
    ///
    /// - Parameters:
    ///   - name: the name of the param
    ///   - defaultValue: the default value of the param
    @inlinable
    public func registerNamedParam<Param>(_ name: String, defaultValue: Param) {
        _node.namedParamChecker.paramInfo[name] = Param.self
        _node.defaultNamedParams[name] = defaultValue
    }

    /// Add unnamed param
    ///
    /// - Parameters:
    ///   - type: the type of the param
    ///   - isRecurring: whether the param is recurring
    @inlinable
    public func registerUnnamedParam<Param>(
        _ type: Param.Type,
        isRecurring: Bool = false
    ) {
        if isRecurring {
            _node.unnamedParamChecker.paramInfo.append(.recurring(type: type))
        } else {
            _node.unnamedParamChecker.paramInfo.append(.single(type: type))
        }
    }

    /// Add a custom semantic stage
    ///
    /// - Parameter customSemanticStage: the custom semantic stage
    public func addCustomSemanticStage(_ customSemanticStage: @escaping SemanticStage) {
        _node.customSemanticStage.append(customSemanticStage)
    }
}
