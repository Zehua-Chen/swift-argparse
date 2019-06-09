//
//  File.swift
//  
//
//  Created by Zehua Chen on 6/9/19.
//

internal struct _Source {

    internal enum Letter: Equatable {
        case undefined
        case letter(_ c: Character)
        case endOfBlock
        case endOfFile
    }

    fileprivate var _source: ArraySlice<String>
    fileprivate var _blocksIterator: ArraySlice<String>.Iterator
    fileprivate var _blockIterator: String.Iterator?

    internal init(using source: ArraySlice<String>) {
        _source = source
        _blocksIterator = _source.makeIterator()
        _blockIterator = _blocksIterator.next()?.makeIterator()
    }

    internal mutating func next() -> Letter {

        // If inside a block, enumerate
        if let letter = _blockIterator?.next() {
            return .letter(letter)
        }

        if let block = _blocksIterator.next() {
            _blockIterator = block.makeIterator()
            return .endOfBlock
        }

        return .endOfFile
    }
}
