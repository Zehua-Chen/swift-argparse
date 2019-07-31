# SwiftArgParse

## Features

- Nested commands (known as "path")
- Parameter type checking

## Get Started

`main.swift`
````swift
import SwiftArgParse

var app = CommandLineApplication(name: "tools")
try! app.add(path: "test") { (context) in
    print("tools-test")
    print(context.optionalParams["-str"] as! String)
}

try! app.add(path: "package") { _ in
    print("tools-package")
}

try! app.run()
````

`bash`
````
./tools test -boolean -str="hello world!"
````
