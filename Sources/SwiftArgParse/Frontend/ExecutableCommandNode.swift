//
//  TerminalCommandNode.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/6/19.
//

/// An executable command node represents a trailing subcommand of a path
@usableFromInline
internal class _ExecutableCommandNode: _CommandNode {

    /// Executor of a command node
    internal var executor: Executor?

    // MARK: Named param related properties

    /// Default named parameter values
    @usableFromInline
    internal var defaultNamedParams = [String: Any]()

    /// Named param checker
    @usableFromInline
    internal var namedParamChecker = NamedParamChecker()

    /// Whehter to check named param
    internal var checksNamedParams = true

    // MARK: Unnamed param related properties
    
    /// Unnamed param checker
    @usableFromInline
    internal var unnamedParamChecker = UnnamedParamTypeChecker()

    /// Whether to run unnamed params
    internal var checksUnnamedParams = true

    // MARK: Semantic stage related properties

    /// Custom semantic stages
    internal var customSemanticStage = [SemanticStage]()

    /// Semantic stages of the executable command node
    internal var semanticStages: [SemanticStage] {
        var stages = [SemanticStage]()

        if self.checksNamedParams {
            stages.append({
                try self.namedParamChecker.check(against: $0)
            })
        }

        if self.checksUnnamedParams {
            stages.append({
                try self.unnamedParamChecker.check(against: $0)
            })
        }

        stages.append(contentsOf: self.customSemanticStage)

        return stages
    }

    /// Create an executable command node from a command node
    ///
    /// - Parameter node: the node to create the executable command node from
    internal init(from node: _CommandNode) {
        super.init(name: node.name, children: node.children)
    }
}
