# Frontend

## Workflow

1. Call `setup` method of all registered commands to create a tree-like configuration, 
where each node corresponds to a command
2. Parse AST
3. Use the configuration object to figure out what section of the command line arguments
represents the path to a registerred command
4. Fetch the appropriate configuration object from the tree
5. Run `struct _OptionProcessor` to
    1. Merge primitives that comes after options into their preceding options, with exception
    of boolean options. Boolean options without explicit values are considered to be true
    2. For each option that use an alias as the name, rename the option with the complete 
    name registered during configuration
    3. Typecheck
5. Run `struct _ParameterChecker` to type check parameters
6. Use the post-processed AST to construct an instance of `struct CommandContext`
    1. `struct CommandContext` is responsible for handling default values
7. Pass the instance of `struct CommandContext` to `func run(with:)` of the appropriate
command

## Error Reporsing and Help Information
