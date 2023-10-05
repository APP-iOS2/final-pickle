//
//  Log.swift
//  Pickle
//
//  Created by 박형환 on 10/5/23.
//

import Foundation


class Log {
    enum Level: String {
        case verbose = "🔎 VERBOSE"
        case debug = "✨ DEBUG"
        case info = "ℹ️ INFO"
        case warning = "⚠️ WARNING"
        case error = "🚨 ERROR"
    }
    
    static private func log(_ message: Any, level: Level, fileName: String, line: Int, funcName: String) {
    #if DEBUG
        let logMessage = "\(message)"
        let head = level.rawValue
        let filename = fileName.components(separatedBy: "/").last
        print("\(Date().format("HH:mm")) [\(head)][\(filename ?? ""), \(line), \(funcName)] - \(logMessage)")
    #endif
    }
}

extension Log {
    static func verbose(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .verbose, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func debug(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .debug, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func info(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .info, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func warning(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .warning, fileName: fileName, line: line, funcName: funcName)
    }
    
    static func error(_ message: Any, fileName: String = #fileID, line: Int = #line, funcName: String = #function) {
        log(message, level: .error, fileName: fileName, line: line, funcName: funcName)
    }
}

