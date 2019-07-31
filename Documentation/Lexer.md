# Lexer 

**The lexer only handle unsigned integers and decimals**, as the minus sign happens 
to be the dash token. Signed integer and decimal processing are defered to AST
composition stage.

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

## Example

````
app -option=true
````

Should be lexed into

- string
- blockSeparator
- dash
- string
- assignment
- boolean(`true`)