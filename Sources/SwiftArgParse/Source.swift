//
//  File.swift
//  
//
//  Created by Zehua Chen on 6/9/19.
//

internal struct _Source {

    internal enum Letter: Equatable {
        case letter(_ c: Character)
        case blockSeparator
    }

    fileprivate var _source: ArraySlice<String>
    fileprivate var _blocksIterator: ArraySlice<String>.Iterator
    fileprivate var _blockIterator: String.Iterator?
    fileprivate var _block: String?

    internal init(using source: ArraySlice<String>) {
        _source = source
        _blocksIterator = _source.makeIterator()
        _blockIterator = _blocksIterator.next()?.makeIterator()
    }

    internal mutating func next() -> Letter? {

        // If inside a block, enumerate
        if let letter = _blockIterator?.next() {
            return .letter(letter)
        }

        if let block = _blocksIterator.next() {
            _block = block
            _blockIterator = _block?.makeIterator()
            return .blockSeparator
        }

        return nil
    }
}
