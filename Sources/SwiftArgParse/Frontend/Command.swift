//
//  Command.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/30/19.
//

/// A path in the command line application
public protocol Command {
    func setup(with config: Configuration)
    func run()
}
