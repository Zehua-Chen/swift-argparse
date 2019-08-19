//
//  main.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/31/19.
//

import SwiftArgParse

var app = CommandLineApplication(name: "example")

app.usePath(["example"]) { (context) in
    print("example")
}

app.usePath(["example", "playground"]) { (context) in
    print("example-print")
    print("unnamed: \(context.unnamedParams))")
    print("named: \(context.namedParams))")
}

let log = app.usePath(["example", "log"]) { (context) in
    print("example-log")
    print("message=\(context.namedParams["--message"] as! String)")
    print("color=\(context.namedParams["--color"] as! String)")
}

log.registerNamedParam("--color", defaultValue: "blue")
log.registerNamedParam("--message", type: String.self)

let add = app.usePath(["example", "add"]) { (context) in
    print("example-add")
    let a = context.unnamedParams[0] as! Int
    let b = context.unnamedParams[1] as! Int
    let c = a + b

    print("\(a) + \(b) = \(c)")
}

add.addUnnamedParam(Int.self)
add.addUnnamedParam(Int.self)

do {
   try app.run()
} catch {
    print(error)
}
