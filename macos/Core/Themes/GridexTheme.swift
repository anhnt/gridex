// GridexTheme.swift
// Gridex
//
// Centralized theme system with adaptive dark/light mode colors and configurable fonts.

import SwiftUI
import AppKit

extension Notification.Name {
    static let themeDidChange = Notification.Name("themeDidChange")
}

enum GridexTheme {
    
    // MARK: - Appearance Detection
    
    static var isDarkMode: Bool {
        NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
    }
    
    static func notifyChange() {
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
    
    // MARK: - Font Sizes (configurable via UserDefaults)
    
    enum FontSize {
        @AppStorage("theme.fontSize.dataGrid") static var dataGrid: Double = 14
        @AppStorage("theme.fontSize.sqlEditor") static var sqlEditor: Double = 16
        @AppStorage("theme.fontSize.sidebar") static var sidebar: Double = 13
        @AppStorage("theme.fontSize.UI") static var ui: Double = 12
        
        static var dataGridFont: NSFont {
            NSFont.monospacedSystemFont(ofSize: dataGrid, weight: .regular)
        }
        
        static var sqlEditorFont: NSFont {
            NSFont.monospacedSystemFont(ofSize: sqlEditor, weight: .regular)
        }
        
        static var sidebarFont: NSFont {
            NSFont.systemFont(ofSize: sidebar, weight: .regular)
        }
        
        static var uiFont: NSFont {
            NSFont.systemFont(ofSize: ui, weight: .regular)
        }
        
        static var dataGridFontSwiftUI: Font {
            .system(size: dataGrid, design: .monospaced)
        }
        
        static var sqlEditorFontSwiftUI: Font {
            .system(size: sqlEditor, design: .monospaced)
        }
        
        static var sidebarFontSwiftUI: Font {
            .system(size: sidebar)
        }
        
        static var uiFontSwiftUI: Font {
            .system(size: ui)
        }
    }
    
    // MARK: - Syntax Highlighting Colors
    
    enum Syntax {
        static let keyword = adaptive(
            light: NSColor(calibratedRed: 0.325, green: 0.290, blue: 0.718, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.55, green: 0.50, blue: 0.90, alpha: 1.0)
        )
        
        static let string = adaptive(
            light: NSColor(calibratedRed: 0.388, green: 0.600, blue: 0.133, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.55, green: 0.78, blue: 0.30, alpha: 1.0)
        )
        
        static let number = adaptive(
            light: NSColor(calibratedRed: 0.847, green: 0.353, blue: 0.188, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.95, green: 0.55, blue: 0.35, alpha: 1.0)
        )
        
        static let comment = adaptive(
            light: NSColor(calibratedRed: 0.533, green: 0.533, blue: 0.502, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.65, green: 0.65, blue: 0.62, alpha: 1.0)
        )
        
        static let function = adaptive(
            light: NSColor(calibratedRed: 0.216, green: 0.541, blue: 0.867, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.40, green: 0.70, blue: 1.0, alpha: 1.0)
        )
        
        static let operatorColor = adaptive(
            light: NSColor(calibratedRed: 0.831, green: 0.325, blue: 0.494, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.90, green: 0.50, blue: 0.65, alpha: 1.0)
        )
    }
    
    // MARK: - Data Grid Colors
    
    enum DataGrid {
        static let cellModified = adaptive(
            light: NSColor(calibratedRed: 0.980, green: 0.933, blue: 0.855, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.25, green: 0.20, blue: 0.10, alpha: 1.0)
        )
        
        static let cellNew = adaptive(
            light: NSColor(calibratedRed: 0.918, green: 0.953, blue: 0.871, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.10, green: 0.20, blue: 0.10, alpha: 1.0)
        )
        
        static let cellDeleted = adaptive(
            light: NSColor(calibratedRed: 0.988, green: 0.922, blue: 0.922, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.25, green: 0.10, blue: 0.10, alpha: 1.0)
        )
        
        static let cellNull = adaptive(
            light: NSColor(calibratedRed: 0.533, green: 0.533, blue: 0.502, alpha: 1.0),
            dark: NSColor(calibratedRed: 0.55, green: 0.55, blue: 0.52, alpha: 1.0)
        )
    }
    
    // MARK: - UI Element Colors
    
    enum UI {
        static let background = adaptive(
            light: NSColor.windowBackgroundColor,
            dark: NSColor.windowBackgroundColor
        )
        
        static let controlBackground = adaptive(
            light: NSColor.controlBackgroundColor,
            dark: NSColor.controlBackgroundColor
        )
        
        static let textPrimary = adaptive(
            light: NSColor.labelColor,
            dark: NSColor.labelColor
        )
        
        static let textSecondary = adaptive(
            light: NSColor.secondaryLabelColor,
            dark: NSColor.secondaryLabelColor
        )
        
        static let separator = adaptive(
            light: NSColor.separatorColor,
            dark: NSColor.separatorColor
        )
        
        static let accent = adaptive(
            light: NSColor.controlAccentColor,
            dark: NSColor.controlAccentColor
        )
    }
    
    // MARK: - Database Type Colors
    
    enum Database {
        static func color(for type: DatabaseType) -> NSColor {
            switch type {
            case .sqlite:
                return adaptive(
                    light: NSColor(calibratedRed: 0.0, green: 0.6, blue: 0.8, alpha: 1.0),
                    dark: NSColor(calibratedRed: 0.2, green: 0.75, blue: 1.0, alpha: 1.0)
                )
            case .postgresql:
                return adaptive(
                    light: NSColor(calibratedRed: 0.2, green: 0.4, blue: 0.7, alpha: 1.0),
                    dark: NSColor(calibratedRed: 0.35, green: 0.55, blue: 0.9, alpha: 1.0)
                )
            case .mysql:
                return adaptive(
                    light: NSColor(calibratedRed: 0.0, green: 0.5, blue: 0.7, alpha: 1.0),
                    dark: NSColor(calibratedRed: 0.2, green: 0.65, blue: 0.9, alpha: 1.0)
                )
            case .redis:
                return adaptive(
                    light: NSColor(calibratedRed: 0.8, green: 0.2, blue: 0.2, alpha: 1.0),
                    dark: NSColor(calibratedRed: 0.95, green: 0.35, blue: 0.35, alpha: 1.0)
                )
            case .mongodb:
                return adaptive(
                    light: NSColor(calibratedRed: 0.15, green: 0.65, blue: 0.4, alpha: 1.0),
                    dark: NSColor(calibratedRed: 0.3, green: 0.8, blue: 0.55, alpha: 1.0)
                )
            case .mssql:
                return adaptive(
                    light: NSColor(calibratedRed: 0.8, green: 0.2, blue: 0.4, alpha: 1.0),
                    dark: NSColor(calibratedRed: 0.9, green: 0.35, blue: 0.55, alpha: 1.0)
                )
            case .clickhouse:
                return adaptive(
                    light: NSColor(calibratedRed: 1.0, green: 0.85, blue: 0.0, alpha: 1.0),
                    dark: NSColor(calibratedRed: 1.0, green: 0.9, blue: 0.2, alpha: 1.0)
                )
            }
        }
    }
    
    // MARK: - MCP Colors
    
    enum MCP {
        static let enabled = adaptive(
            light: NSColor.systemGreen,
            dark: NSColor.systemGreen
        )
        
        static let disabled = adaptive(
            light: NSColor.secondaryLabelColor,
            dark: NSColor.secondaryLabelColor
        )
        
        static func modeColor(for mode: MCPConnectionMode) -> NSColor {
            switch mode {
            case .locked:
                return adaptive(
                    light: NSColor.systemRed,
                    dark: NSColor.systemRed
                )
            case .readOnly:
                return adaptive(
                    light: NSColor.systemOrange,
                    dark: NSColor.systemOrange
                )
            case .readWrite:
                return adaptive(
                    light: NSColor.systemGreen,
                    dark: NSColor.systemGreen
                )
            }
        }
    }
    
    // MARK: - Helper
    
    private static func adaptive(light: NSColor, dark: NSColor) -> NSColor {
        NSColor(name: nil) { appearance in
            appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua ? dark : light
        }
    }
}

// MARK: - SwiftUI Color Extensions

extension Color {
    enum Theme {
        static let syntaxKeyword = Color(nsColor: GridexTheme.Syntax.keyword)
        static let syntaxString = Color(nsColor: GridexTheme.Syntax.string)
        static let syntaxNumber = Color(nsColor: GridexTheme.Syntax.number)
        static let syntaxComment = Color(nsColor: GridexTheme.Syntax.comment)
        static let syntaxFunction = Color(nsColor: GridexTheme.Syntax.function)
        static let syntaxOperator = Color(nsColor: GridexTheme.Syntax.operatorColor)
        
        static let cellModified = Color(nsColor: GridexTheme.DataGrid.cellModified)
        static let cellNew = Color(nsColor: GridexTheme.DataGrid.cellNew)
        static let cellDeleted = Color(nsColor: GridexTheme.DataGrid.cellDeleted)
        static let cellNull = Color(nsColor: GridexTheme.DataGrid.cellNull)
    }
}

// MARK: - SwiftUI Font Extensions

extension Font {
    enum Theme {
        static var dataGrid: Font { GridexTheme.FontSize.dataGridFontSwiftUI }
        static var sqlEditor: Font { GridexTheme.FontSize.sqlEditorFontSwiftUI }
        static var sidebar: Font { GridexTheme.FontSize.sidebarFontSwiftUI }
        static var ui: Font { GridexTheme.FontSize.uiFontSwiftUI }
    }
}
