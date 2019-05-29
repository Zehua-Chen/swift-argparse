# Syntax

````
app-name subcommands... options...
````

Command line AST is organized in the form of an array, unlike a typical tree
structure.

The AST has three clusters:
1. Subcommands (including the main app command)
2. Required Parameters
3. Optional Parameters

## Rules

- **Subcommands** must come first
- **Required** parameters must be ordered
- **Optional** parameters can be unordered and be inserted in-between required
parameters
