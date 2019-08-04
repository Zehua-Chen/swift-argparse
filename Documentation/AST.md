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
dash(s) string assignment/endBlock string|bolean
````

````
dash(s) string assignment/endBlock (dash) uint|udecimal
````

- The first string, **combined with the dashes** is the `name` of an optional param;
- Whatever comes after the `assignment` or `endBlock` is the `value`;

An implicit `true` optional param is produced when

- When the block is followed by what can be the start of a new optional param (dashes and 
string);
- When the block is the last one in the array

````
dash(s) string endBlock dash(s) string ...
````

````
dash(s) string endBlock
````
