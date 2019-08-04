# AST

````
app-name command param -options...
````

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
dash(s) string assignment/"end block" string|bolean
````

````
dash(s) string assignment/"end block" (dash) uint|udecimal
````

- The first string, **combined with the dashes** is the `name`;
- Whatever comes after the `assignment` is the `value`;

A simpler form in which the optional param is considered to be a `boolean(true)` is 
also allowed:

````
dash(s) string dash(s) string
````

````
dash(s) string
````
