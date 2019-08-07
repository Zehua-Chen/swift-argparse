//
//  TerminalCommandNode.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/6/19.
//

internal class _ExecutableCommandNode: _CommandNode {
    internal var executor: Executor?

    // MARK: Optional param related properties

    internal var defaultOptionalParams = [String: Any]()
    internal var optionalParamTypeChecker = OptionalParamChecker()
    internal var checksOptionalParam = true

    internal var semanticStages: [SemanticStage] {
        var stages = [SemanticStage]()

        if self.checksOptionalParam {
            stages.append({
                return self.optionalParamTypeChecker.check(context: $0).mapError {
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
