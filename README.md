# SwiftArgParse

## Features

- Nested commands (known as "path");
- Parameter type checking;

## Terminologies

````
commands parameters -options
````

The command line arguments are parsed into these parts
1. Commands (`swift build`)
2. Parameters (`main.swift`)
3. Options (`-c build`)

The input of parameters must match a defined regular expression during the application's 
setup. For example

```
.single(String.self),
.recurring(Int.self),
.single(Bool.self)
```

must have parameters in the with one string at the head and a boolean at the tail with 
an unlimited amount of integers in-between.

### Types

The types of parameters and options are implemented using Swift Standard Library's types,
such as `Swift.Int`, `Swift.Bool`, `Swift.String` etc.

### Command

```
app generate parameters
```

Each command is associated with an array of strings known as the command's path.
In the above example, the path will be `["app", "generate"]`

