//
//  File.swift
//  
//
//  Created by Zehua Chen on 6/7/19.
//

internal struct _Source {
    var data: [String]
    var blockCursor: Array<String>.Iterator
    var charCursor: String.Iterator?

    init(from data: [String]) {
        self.data = data
        self.blockCursor = self.data.makeIterator()
        self.charCursor = self.blockCursor.next()?.makeIterator()
    }

    mutating func next() -> Character? {
        // If not at the end of the current block, read
        if let char = self.charCursor?.next() {
            return char
        }

        // Advance to the next block
        if let block = self.blockCursor.next() {
            self.charCursor = block.makeIterator()
            return self.charCursor!.next()
        }

        return nil
    }
}
