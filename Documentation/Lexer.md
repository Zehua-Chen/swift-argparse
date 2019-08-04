# Lexer 

## Lexical Rules

- A block is defined to be a string element in the array that contains the command line 
arguments;
- A "endBlock" is a virtual token inserted at the end of each block to assist AST parsing;

### Example

````
app -option=true
````

Should be lexed into

- string
- *endBlock*
- dash
- string
- assignment
- boolean(`true`)
- *endBlock*

## Implementation

````swift
public enum Token: Equatable {
    case string(_ value: String)
    case boolean(_ value: Bool)
    case uint(_ value: UInt)
    case udecimal(_ value: Double)
    case dash
    case assignment
    case endBlock
}

````

- **string**: anything made up of alphabs that are not `true` or `false`
- **boolean**: either `true` or `false`
- **uint**: an unsigned integer
- **udecimal**: an unsigned decimal
- **dash**: the `-` character
- **assignment**: the `=` character
- **endBlock**: the space between two chuncks of command line argument
