//
//  Source.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 6/9/19.
//

internal struct _Source: Sequence, IteratorProtocol {

    internal enum Element: Equatable {
        case character(_ c: Character)
        case endBlock
    }

    fileprivate enum _State {
        case startBlock(from: String, index: String.Index)
        case inbBlock(from: String, index: String.Index)
        case endBlock
        case endFile
    }

    /// Current point in the input source
    internal var point: SourcePoint = .init(block: -1, index: -1)

    fileprivate var _inputIter: ArraySlice<String>.Iterator
    fileprivate var _state: _State

    /// Create a source from a given input
    ///
    /// - Parameter input: the input to use
    internal init(input: ArraySlice<String>) {
        _inputIter = input.makeIterator()

        if input.isEmpty {
            _state = .endFile
        } else {
            let s = _inputIter.next()!
            _state = .startBlock(from: s, index: s.startIndex)
        }
    }

    internal mutating func next() -> Element? {
        switch _state {
        case .startBlock(let str, let index):
            self.point.block += 1
            self.point.index = -1

            fallthrough
        case .inbBlock(let str, var index):
            let c = str[index]
            self.point.index += 1
            str.formIndex(after: &index)

            if index < str.endIndex {
                _state = .inbBlock(from: str, index: index)
            } else {
                _state = .endBlock
            }

            return .character(c)
        case .endBlock:
            self.point.index += 1
            
            if let str = _inputIter.next() {
                _state = .startBlock(from: str, index: str.startIndex)
            } else {
                _state = .endFile
            }

            return .endBlock
        case .endFile:
            return nil
        }
    }
}
