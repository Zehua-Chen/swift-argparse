//
//  main.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 7/31/19.
//

import SwiftArgParse

var app = CommandLineApplication(name: "example")

try! app.add(path: ["example"]) { (context) in
    print("example")
}

try! app.add(path: ["example", "playground"]) { (context) in
    print("example-print")
    print("unnamed: \(context.unnamedParams))")
    print("named: \(context.namedParams))")
}

let log = try! app.add(path: ["example", "log"]) { (context) in
    print("example-log")
    print("message=\(context.namedParams["--message"] as! String)")
    print("color=\(context.namedParams["--color"] as! String)")
}

log.add(namedParam: "--color", defaultValue: "blue")
log.add(namedParam: "--message", type: String.self)

let add = try! app.add(path: ["example", "add"]) { (context) in
    print("example-add")
    let a = context.unnamedParams[0] as! Int
    let b = context.unnamedParams[1] as! Int
    let c = a + b

    print("\(a) + \(b) = \(c)")
}

add.add(unnamedParam: Int.self)
add.add(unnamedParam: Int.self)

do {
   try app.run()
} catch {
    print(error)
}
