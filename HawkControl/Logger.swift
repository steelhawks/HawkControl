//
//  Logger.swift
//  HawkControl
//
//  Created by Farhan Jamil on 6/30/24.
//

import Foundation

enum LogLevel: String {
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
}

class Logger: ObservableObject {
    static let shared = Logger()
    
    private init() { }
    
    @Published var logs: [String] = []
    
    func log(_ message: String, level: LogLevel = .info) {
        let logMessage = "\(Date()): [\(level.rawValue)] \(message)"
        logs.append(logMessage)
    }
}
