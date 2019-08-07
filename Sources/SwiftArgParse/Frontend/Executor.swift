//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

/// An executor is a method that run a piece of code using a parsed `ASTContext`
public protocol Executor {
    func run(with context: ASTContext)
}

/// A closure executor takes a piece of closure and pass it a `ASTContext`
public struct ClosureExecutor: Executor {
    public typealias Closure = (_ context: ASTContext) -> Void
    let executor: Closure

    public func run(with context: ASTContext) {
        self.executor(context)
    }
}
