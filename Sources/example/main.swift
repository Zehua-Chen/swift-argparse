//
//  main.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/31/19.
//

import SwiftArgParse

struct SubA: Command {
    func setup(with config: Configuration) {
    }

    func run() {
    }
}

struct Application: Command {
    func setup(with config: Configuration) {
        config.use(SubA(), for: "suba")
    }

    func run() {
    }
}

CommandLine.run(Application())
