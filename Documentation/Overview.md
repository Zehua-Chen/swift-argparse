# Overview

````
app-name subcommands... parameters...
````

The command line arguments are defined to have three parts
1. Subcommands (including the main app command)
2. Unabled required parameters
3. Named optional parameters

## Parts

- **Subcommands** must come first;
- **Required** and **optional** params must come after **subcommands** but do not 
have to be ordered;
- Even though **required** params can be mixed with optional params, **required** params 
are stored with orders;
