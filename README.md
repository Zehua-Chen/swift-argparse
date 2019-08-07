# SwiftArgParse

## Features

- Nested commands (known as "path")
- Parameter type checking

## Get Started

Add this package as a dependency in your Swift Package Manifest

`main.swift`
````swift
import SwiftArgParse

var app = CommandLineApplication(name: "example")

try! app.addPath(["example"]) { (context) in
    print("example")
}

try! app.addPath(["example", "playground"]) { (context) in
    print("example-print")
    print("unnamed: \(context.unnamedParams))")
    print("named: \(context.namedParams))")
}

let log = try! app.addPath(["example", "log"]) { (context) in
    print("example-log")
    print("message=\(context.namedParams["--message"] as! String)")
    print("color=\(context.namedParams["--color"] as! String)")
}

log.registerNamedParam("--color", defaultValue: "blue")
log.registerNamedParam("--message", type: String.self)

let add = try! app.addPath(["example", "add"]) { (context) in
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

````

`bash`
````
./example print -boolean -str="hello world!"
````

## Terminologies

````
app-name subcommands... parameters...
````

The command line arguments are defined to have three parts
1. Subcommands (`swift build`)
2. Unamed parameters (`main.swift`)
3. Named parameters (`-c build`)

- **Subcommands** must come first;
- **Unnamed** and **named** params can be mixed together, but unnamed parameters
are store the order they occur

### Paths

- A sequence of subcommands form a path;
- The trailing subcommand of a path represents a subprogram that is executed in the current
invocation
