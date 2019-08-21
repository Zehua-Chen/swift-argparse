//
//  PathResolver.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 8/21/19.
//

fileprivate typealias _Path = _ASTContext.Path

internal struct _PathResolver {
    func run(on context: inout _ASTContext, with root: Configuration) {
        var node = root

        for i in 0..<context.elements.count {
            // Elements are allowed to be nil
            guard let element = context.elements[i] else { continue }
            // Stop upon the first non-primitive
            guard case .primitive(let p) = element else { return }
            // Stop upn the first non string primitive (only string primitive
            // can be path)
            guard let name = p.value as? String else { return }
            // Stop at the end of the configuration
            guard node.children[name] != nil else { return }

            // Change context's content
            node = node.children[name]!
            context.elements[i] = .path(_Path(value: name, location: element.location))
        }
    }
}
