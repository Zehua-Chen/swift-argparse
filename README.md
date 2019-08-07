# SwiftArgParse

## Features

- Nested commands (known as "path")
- Parameter type checking

## Get Started

`main.swift`
````swift
import SwiftArgParse

var app = CommandLineApplication(name: "example")

try! app.add(path: ["example"]) { (context) in
    print("example")
}

try! app.add(path: ["example", "print"]) { (context) in
    print("unnamed: \(context.unnamedParams))")
    print("named: \(context.namedParams))")
}

try! app.run()
````

`bash`
````
./example print -boolean -str="hello world!"
````
