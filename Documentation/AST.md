# AST

````
app-name command param -options...
````

- Each declaration except the last one should end with a block separator token.
- The parsed result is stored in `struct ASTContext`

## AST Rules

### Subcommand

````
string
````

### Required Parameter

````
string
````

- Required parameters are treated like subcommands until the semantic stage.

### Optional Parameters

````
dash(s) string assignment (dash) string|uint|udecimal|boolean
````

- The first string, combined with the dashes is the `name`;
- Whatever comes after the `assignment` is the `value`;
