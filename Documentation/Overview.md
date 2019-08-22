# Overview

The project is divided into three parts

1. `Sources/Source`: provides utilities for reading from the array of
command line arguments (ex. Location, Inserting virtual end block character)

2. `Sources/AST`: parse tokens from a source and construct
`internal struct ASTContext` using the tokens. For more information, go to
`Documentation/AST.md`

3. `Sources/Sema`: AST manipulation and type check, for more information,
go to `Documentation/Semantics.md`

4. `Sources/Frontend`: the driver that parse AST, execute Semantic stages,
executing the appropriate command. For more information, go to
`Documentation/Frontend.md`

## Project Structure

- Each library target in `Sources/` folder correspond to a `Tests/` folder;
- Each folder in a library target folder in mirros to a folder in the
corresponding test target folder
