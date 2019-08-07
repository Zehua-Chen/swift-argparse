# AST

````
app-name command unnamed_params -named_params...
````

- The parsed result is stored in `struct ASTContext`

## AST Rules

### Subcommand

````
string
````

### Unnamed Parameters

````
string|boolean
(dash) uint|udecimal
````
- Other unnamed param types are treated as params

### Named Parameters

````
dash(s) string assignment/endBlock string|bolean
````

````
dash(s) string assignment/endBlock (dash) uint|udecimal
````

- The first string, **combined with the dashes** is the `name` of an named param;
- Whatever comes after the `assignment` or `endBlock` is the `value`;

An implicit `true` named param is produced when

- When the block is followed by what can be the start of a new named param (dashes and 
string);
- When the block is the last one in the array

````
dash(s) string endBlock dash(s) string ...
````

````
dash(s) string endBlock
````
