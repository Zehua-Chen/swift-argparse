//
//  TerminalCommandNode.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/6/19.
//

@usableFromInline
internal class _ExecutableCommandNode: _CommandNode {
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

    internal var customSemanticStage = [SemanticStage]()

    internal var semanticStages: [SemanticStage] {
        var stages = [SemanticStage]()

        if self.checksNamedParams {
            stages.append({
                return self.namedParamChecker.check(against: $0).mapError {
                    return $0 as Error
                }
            })
        }

        if self.checksUnnamedParams {
            stages.append({
                return self.unnamedParamChecker.check(against: $0).mapError {
                    return $0 as Error
                }
            })
        }

        stages.append(contentsOf: self.customSemanticStage)

        return stages
    }

    internal init(from node: _CommandNode) {
        super.init(name: node.name, children: node.children)
    }
}
