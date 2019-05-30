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

## AST Nodes

### Subcommand

#### Properties

- (`string`): name

### Optional Parameters

#### Properties

- (`string`): name (including `-`)
- (`string | number | boolean`): value

### Required Parameters

##### Properties

- (`string`) value
