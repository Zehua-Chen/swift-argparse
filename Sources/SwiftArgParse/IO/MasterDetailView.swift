//
//  MasterDetailView.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 9/14/19.
//

/// Master detail view that can be printed to text
internal struct _MasterDetailView: CustomStringConvertible {

    /// A row in the master detail view
    internal struct Row {
        var master: String
        var detail: String
    }

    /// Title of this view
    internal var title: String

    /// Spacing between the master and the detail
    internal var spacing: Int {
        didSet {
            _space = String(repeating: " ", count: self.spacing)
        }
    }

    /// Indent of each row
    internal var indent: Int {
        didSet {
            _indent = String(repeating: " ", count: self.indent)
        }
    }

    /// Rows of this view
    internal fileprivate(set) var rows: [Row] = .init()

    /// Count of the row with the longest master content
    fileprivate var _maxMasterCount: Int = 0

    /// Space string used in print
    fileprivate var _space: String = ""

    /// Indent string used in print
    fileprivate var _indent: String = ""

    /// Create a new master detail view
    ///
    /// - Parameters:
    ///   - title: title of the view
    ///   - spacing: spacing
    ///   - indent: indent
    internal init(title: String = "", spacing: Int = 2, indent: Int = 2) {
        self.title = title
        self.spacing = spacing
        self.indent = indent

        _indent = String(repeating: " ", count: self.indent)
        _space = String(repeating: " ", count: self.spacing)
    }

    /// Create a string printout of this view
    internal var description: String {
        var temp = ""
        self.print(to: &temp)

        return temp
    }

    /// Print the view to a target text output stream
    ///
    /// - Parameter target: a target to print to
    internal func print<Target: TextOutputStream>(to target: inout Target) {
        target.write("\(self.title):\n")

        for row in self.rows {
            var master = row.master
            let masterCount = master.count

            if masterCount < _maxMasterCount {
                master.reserveCapacity(_maxMasterCount)
                master.append(String(repeating: " ", count: _maxMasterCount - masterCount))
            }

            Swift.print("\(_indent)\(master)\(_space)\(row.detail)", to: &target)
        }

        target.write("\n")
    }

    /// Append new row
    ///
    /// - Parameter row: the new row
    internal mutating func append(_ row: Row) {
        let masterCount = row.master.count

        if masterCount > _maxMasterCount {
            _maxMasterCount = masterCount
        }

        self.rows.append(row)
    }

    /// Remove all rows
    internal mutating func removeAll() {
        self.rows.removeAll()
    }
}
