# AST

The AST stage is dedicated to purely parse an AST of the user input without any 
setup information or type resolving. 

The AST is implemented as an array of declarations. The declarations are:

- Primitive declaration
- Option declaration

## Primitive Declaration

A primitive declaration can be either of the following
- string and boolean without prefix dashes;
- integer and double with an optional prefix dash to denote a negative value

## Option Declaration

An option is made up of either `1-2` or `1-4`

1. any number of dashes
2. string
3. assignment operator 
4. value, which can be any of the following:
    1. string or boolean
    2. integer and double with a dash prefix to denote negativity

## Location

All AST nodes should have a location associated with it.

## Note

The following are defered to the semantic stage:

- path resolving
- abbreviated `true` options i.e. `-option`;
- `-option value` parsing (AST handles `-option=value`);
