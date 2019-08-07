//
//  TerminalCommandNode.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/6/19.
//

internal class _ExecutableCommandNode: _CommandNode {
    internal var executor: Executor?

    // MARK: Named param related properties

    internal var defaultNamedParams = [String: Any]()
    internal var namedParamChecker = NamedParamChecker()
    internal var checkNamedParam = true

    internal var semanticStages: [SemanticStage] {
        var stages = [SemanticStage]()

        if self.checkNamedParam {
            stages.append({
                return self.namedParamChecker.check(context: $0).mapError {
                    return $0 as Error
                }
            })
        }

        return stages
    }

    internal init(from node: _CommandNode) {
        super.init(name: node.name, children: node.children)
    }
}
