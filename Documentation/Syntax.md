# Syntax

````
app-name subcommands... parameters...
````

The command line arg AST is organized in the form of an array,
unlike a typical tree structure.

The AST has three types of nodes:
1. Subcommands (including the main app command)
2. Required Parameters
    - Unnamed;
3. Optional Parameters
    - Named;

## Positional Rules

- **Subcommands** must come first
- **Required** parameters must be ordered
- **Optional** parameters can be unordered and be inserted in-between required
parameters

## Syntax Rules
A name is defined as a string that starts with alphbets and optionally contain `-` or `_` 
in between.

### Subcommands
Subcommands are names without modification.

````
compile
````

### Optional Parameters
Optional parameters are names that starts with a `-`

````
-flag
--flag
````

### Required Parameters
Required parameters use the same syntax as subcommands

## AST Nodes

### Name
The distinction between subcommand and required parameters will be made
after semantic analysis.

#### Properties

- (`string`): value

### Optional Parameters

#### Properties

- (`string`): name (including `-`)
- (`string | number | boolean`): value

