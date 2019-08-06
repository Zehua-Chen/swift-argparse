//
//  TerminalCommandNode.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/6/19.
//

internal class _TerminalCommandNode: _CommandNode {
    internal var executor: Executor?
    internal var defaultOptionalParams: ASTContext.OptionalParamsType?
    internal var semanticStages = [SemanticStage]()

    internal init(from node: _CommandNode) {
        super.init(name: node.name, children: node.children)
    }
}
