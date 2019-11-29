//
//  File.swift
//  
//
//  Created by Zehua Chen on 11/29/19.
//

import Foundation

/// Text output stream to standard error
struct StandardErrorTextOutputStream: TextOutputStream {

    /// Default standard error output stream
    static var `default` = StandardErrorTextOutputStream(handle: .standardError)

    fileprivate var _handle: FileHandle

    /// Create from a file handle
    /// - Parameter handle: the standard error handle to use with the text output stream
    init(handle: FileHandle) {
        _handle = handle
    }

    func write(_ string: String) {
        guard let data = string.data(using: .utf8) else { return }
        _handle.write(data)
    }
}
