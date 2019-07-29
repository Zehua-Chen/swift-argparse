//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/29/19.
//

public protocol Command {
    func run(with context: ASTContext)
}

public struct ClosureCommand: Command {
    let closure: (_ context: ASTContext) -> Void

    public func run(with context: ASTContext) {
        self.closure(context)
    }
}
