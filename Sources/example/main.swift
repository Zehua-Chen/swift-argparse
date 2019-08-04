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
    print("required: \(context.requiredParams))")
    print("optional: \(context.optionalParams))")
}

do {
   try app.run()
} catch {
    print(error)
}
