//
//  OptionMerger.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/22/19.
//

public enum OptionError: Error {
    case unrecogznied(name: String, location: SourceLocation)
    case typeMismatch(name: String, expecting: Any.Type, found: Any.Type, location: SourceLocation)
}

internal struct _OptionProcessor {

    /// Execute option processor with the following stages `merge->alias->check`
    ///
    /// - Parameters:
    ///   - context: the context to work with
    ///   - config: configuration that containing information about options
    /// - Throws: OptionError
    internal func run(on context: inout _ASTContext, with config: Configuration) throws {
        self.merge(&context, with: config)
        self.alias(&context, with: config)
        try self.check(context, with: config)
    }

    /// Merge an option with an upcoming primitive.
    ///
    /// An option can be merged only if
    /// - there is an upcoming primitive
    /// - the option does not have value
    /// - the option is not boolean
    /// boolean options are considered to be `true` without any mergin
    ///
    /// - Parameters:
    ///   - context: the context to work with
    ///   - config: description containing the options
    internal func merge(_ context: inout _ASTContext, with config: Configuration) {
        for i in 0..<context.elements.count {
            // Match non null elements that needs merging
            guard let element = context.elements[i] else { continue }
            guard case .option(var option) = element else { continue }
            guard option.value == nil else { continue }

            let hasNextElement = i < context.elements.count - 1

            // Trailing elements is considered to be true regardless of
            // configuration
            if !hasNextElement {
                option.value = true
                context.elements[i] = .option(option)
                continue
            }

            // Get corresponding option from configuration
            guard let optionConfig = config.options[option.name] else { continue }

            // Merge boolean
            if optionConfig.type == Bool.self {
                option.value = true
                context.elements[i] = .option(option)
                continue
            }

            // Merge other types of non-trailing options
            guard let nextElement = context.elements[i + 1] else { continue }
            guard case .primitive(let primitive) = nextElement else { continue }

            // Merge with upcoming primitive
            context.elements[i + 1] = nil
            option.value = primitive.value
            context.elements[i] = .option(option)
        }
    }

    /// Replace options with names registered as alias with the name that the
    /// alias points to
    ///
    /// - Parameters:
    ///   - context: the context to work with
    ///   - config: a configuration object containing the alias information
    internal func alias(_ context: inout _ASTContext, with config: Configuration) {
        for i in 0..<context.elements.count {
            // Fetch non-nil, option elements
            guard let element = context.elements[i] else { continue }
            guard case .option(var option) = element else { continue }

            // If current name is an alias
            guard let aliased = config.optionAliases[option.name] else { continue }
            option.name = aliased

            context.elements[i] = .option(option)
        }
    }

    /// Type check options
    ///
    /// - Parameters:
    ///   - context: the context to check
    ///   - config: the configuration to get type from
    /// - Throws: OptionError
    internal func check(_ context: _ASTContext, with config: Configuration) throws {
        for i in 0..<context.elements.count {
            guard let element = context.elements[i] else { continue }
            guard case .option(let option) = element else { continue }

            guard let expectingType = config.options[option.name]?.type else {
                if config.allowsUnregisteredOptions {
                    continue
                }

                throw OptionError.unrecogznied(name: option.name, location: option.location)
            }

            let actualType = type(of: option.value!)

            if actualType != expectingType {
                throw OptionError.typeMismatch(
                    name: option.name,
                    expecting: expectingType,
                    found: actualType,
                    location: option.location)
            }
        }
    }
}
