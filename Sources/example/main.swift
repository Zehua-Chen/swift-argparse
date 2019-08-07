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

try! app.add(path: ["example", "print"]) { (context) in
    print("example-print")
    print("unnamed: \(context.unnamedParams))")
    print("named: \(context.namedParams))")
}

do {
   try app.run()
} catch {
    print(error)
}
