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

### Required Parameters

````
string|boolean
(dash) uint|udecimal
````
- Other required param types are treated as params

### Optional Parameters

````
dash(s) string assignment (dash) string|uint|udecimal|boolean
````

- The first string, **combined with the dashes** is the `name`;
- Whatever comes after the `assignment` is the `value`;

A simpler form in which the optional param is considered to be a `boolean(true)` is 
also allowed:

````
dash(s) string
````
