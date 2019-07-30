//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

public protocol Executor {
    func run(with context: ASTContext)
}

public struct ClosureExecutor: Executor {
    public typealias Closure = (_ context: ASTContext) -> Void
    let executor: Closure

    public func run(with context: ASTContext) {
        self.executor(context)
    }
}
