# Lexer 

## Lexical Rules

### What is a "block"?

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

- Tokens are implemented in `AST/Token.swift`
- The lexer is implemented in `AST/Lexer.swift`
