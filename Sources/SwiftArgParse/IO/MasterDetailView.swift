//
//  MasterDetailView.swift
//  SwiftArgParse
//
//  Created by Zehua Chen on 9/14/19.
//

internal struct _MasterDetailView: CustomStringConvertible {
    internal struct Row {
        var master: String
        var detail: String
    }

    internal var title: String
    internal fileprivate(set) var rows: [Row] = .init()
    fileprivate var _maxMasterCount: Int = 0

    internal init(title: String) {
        self.title = title
    }

    internal var description: String {
        var temp = ""
        self.print(to: &temp)

        return temp
    }

    internal func print<Target: TextOutputStream>(to target: inout Target) {
        target.write("\(self.title):\n")

        for row in self.rows {
            var master = row.master
            let masterCount = master.count

            if masterCount < _maxMasterCount {
                master.reserveCapacity(_maxMasterCount)
                master.append(String(repeating: " ", count: _maxMasterCount - masterCount))
            }

            Swift.print("\(master)\(row.detail)", to: &target)
        }

        target.write("\n")
    }

    internal mutating func append(_ row: Row) {
        let masterCount = row.master.count

        if masterCount > _maxMasterCount {
            _maxMasterCount = masterCount
        }

        self.rows.append(row)
    }

    internal mutating func removeAll() {
        self.rows.removeAll()
    }
}
