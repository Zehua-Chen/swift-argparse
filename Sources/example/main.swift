//
//  main.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/31/19.
//

import SwiftArgParse

struct SubA: Command {
    func setup(with config: Configuration) {
        config.use(Parameter(type: String.self))
        config.use(Option(name: "--age", defaultValue: 0))
    }

    func run(with context: CommandContext) {
        print(context.age as! Int)
        print(context[0] as! String)
    }
}

struct Application: Command {
    func setup(with config: Configuration) {
        config.use(SubA(), for: "suba")
    }

    func run(with context: CommandContext) {
    }
}

try! CommandLine.run(Application())
