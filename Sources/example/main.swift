//
//  main.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/31/19.
//

import SwiftArgParse

struct Calculator: Command {
    func setup(with config: Configuration) {
        config.use(Parameter(type: Double.self))
        config.use(Parameter(type: Double.self))
    }

    func run(with context: CommandContext) {
        let result = (context[0] as! Double) + (context[1] as! Double)
        print("result = \(result)")
    }
}

struct Application: Command {
    func setup(with config: Configuration) {
        config.use(Calculator(), for: "calc")
        config.use(Option(name: "--hello", defaultValue: false))
    }

    func run(with context: CommandContext) {
        if context.hello as! Bool {
            print("hello world")
        }
    }
}

try! CommandLine.run(Application())
