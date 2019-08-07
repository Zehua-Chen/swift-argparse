//
//  Source.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/9/19.
//

internal struct _Source: Sequence, IteratorProtocol {

    internal enum Item: Equatable {
        case character(_ c: Character)
        case endBlock
    }

    typealias Element = Item
    typealias Input = ArraySlice<String>

    fileprivate var _input: Input
    /// An iterator used to navigate blocks
    fileprivate var _blocksIterator: Input.Iterator
    /// An iterator used to navigate a single block
    fileprivate var _blockIterator: String.Iterator?
    fileprivate var _block: String?

    internal init(input: Input) {
        _input = input
        _blocksIterator = _input.makeIterator()
        _blockIterator = _blocksIterator.next()?.makeIterator()
    }

    internal mutating func next() -> Item? {

        // If inside a block, enumerate
        if let letter = _blockIterator?.next() {
            return .character(letter)
        }

        if let block = _blocksIterator.next() {
            _block = block
            _blockIterator = _block?.makeIterator()
            return .endBlock
        }

        return nil
    }
}
