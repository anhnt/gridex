// NSColor+Gridex.swift
// Gridex
//
// App-specific color constants with dark mode support.
// Uses GridexTheme for centralized color management.

import SwiftUI
import AppKit

extension Color {
    enum Gridex {
        // Syntax highlighting (delegated to Theme)
        static let syntaxKeyword = Color.Theme.syntaxKeyword
        static let syntaxString = Color.Theme.syntaxString
        static let syntaxNumber = Color.Theme.syntaxNumber
        static let syntaxComment = Color.Theme.syntaxComment
        static let syntaxFunction = Color.Theme.syntaxFunction
        static let syntaxOperator = Color.Theme.syntaxOperator

        // Data grid (delegated to Theme)
        static let cellModified = Color.Theme.cellModified
        static let cellNew = Color.Theme.cellNew
        static let cellDeleted = Color.Theme.cellDeleted
        static let cellNull = Color.Theme.cellNull
    }
}

// NSColor bridge — appearance-aware data grid colors
extension NSColor {
    enum Gridex {
        // Syntax highlighting (delegated to Theme)
        static let syntaxKeyword = GridexTheme.Syntax.keyword
        static let syntaxString = GridexTheme.Syntax.string
        static let syntaxNumber = GridexTheme.Syntax.number
        static let syntaxComment = GridexTheme.Syntax.comment
        static let syntaxFunction = GridexTheme.Syntax.function
        static let syntaxOperator = GridexTheme.Syntax.operatorColor

        // Data grid (delegated to Theme)
        static let cellModified = GridexTheme.DataGrid.cellModified
        static let cellNew = GridexTheme.DataGrid.cellNew
        static let cellDeleted = GridexTheme.DataGrid.cellDeleted
        static let cellNull = GridexTheme.DataGrid.cellNull
    }
}
