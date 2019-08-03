# Lexer 

## Lexical Rules

- **End block**: a block is defined to be an element in the command line argument 
array; a block separator is defined to be the "space" between two blocks

### Example

````
app -option=true
````

Should be lexed into

- string
- endBlock
- dash
- string
- assignment
- boolean(`true`)

## Implementation

````swift
internal enum _Token: Equatable {
    case string(_ value: String)
    case boolean(_ value: Bool)
    case uint(_ value: UInt)
    case udecimal(_ value: Double)
    case dash
    case assignment
    case blockSeparator
}
````

- **string**: anything inside a pair of quotation marks
- **boolean**: either `true` or `false`
- **uint**: an unsigned integer
- **udecimal**: an unsigned decimal
- **dash**: the `-` character
- **assignment**: the `=` character
- **blockSeparator**: the space between two chuncks of command line argument
