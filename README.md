# Swift Argument Parser

## Features

- [x] Nested commands
- [x] Type checking for options and parameters
- [ ] Help information

## Get Started

The package requires Swift 5 or above to build

1. Add the project to your swift package manifest

```swift
// dependencies section
.package(url: "https://github.com/Zehua-Chen/swift-argparse.git", from: "2.0.0")
// target section
.target(name: "example", dependencies: ["SwiftArgParse"]
```

2. Add the following line to your application

```swift
struct SubA: Command {
    func setup(with config: Configuration) {
        config.use(Parameter(type: String.self))
        config.use(Option(name: "--age", defaultValue: 0))
    }

    func run(with context: CommandContext) {
        print(context.age as! Int)
        print(context[0] as! String)
    }
}

struct Application: Command {
    func setup(with config: Configuration) {
        config.use(SubA(), for: "suba")
    }

    func run(with context: CommandContext) {
    }
}

try! CommandLine.run(Application())
```

3. Build and run wit the following arguments
```
./example suba "hello world" --age=2
```

## Terminologies

````
commands parameters -options
````

The command line arguments are parsed into these parts
1. Commands (`swift build`)
2. Parameters (`main.swift`)
3. Options (`-c build`)

### Parameters

The input of parameters must match a defined regular expression during the application's 
setup. For example

```
Parameter(type: String.self)
Parameter(type: Int.self, isRepeating: true)
Parameter(type: Bool)
```

must have parameters in the with one string at the head and a boolean at the tail with 
an unlimited amount of integers in-between.

All of the parameters are required

### Options

- All of the options are not requried;
- Options can have a defualt value, in which case if the user does not enter the option,
the default value will be inserted into `public struct CommandContext`

### Types

The types of parameters and options are implemented using Swift Standard Library's types,
such as `Swift.Int`, `Swift.Bool`, `Swift.String` etc.

### Command

```
app generate parameters
```

Each command is associated with an array of strings known as the command's path.
In the above example, the path will be `["app", "generate"]`

## Implementation

Go to `Documents/Overview.md` to learn more about the implementation about the package
