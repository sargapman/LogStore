//
//  LogStore.swift
//  LogStore Package
//
//  Created by Monty Boyer on 5/4/20.
//  Copyright © 2020 Monty Boyer. All rights reserved.
//

import Foundation

struct LogEntry: Codable {
    let entryText: String
    let entryTime: Date
}

struct LogStore {
    static var log: [LogEntry] = []     // the single instance of the log array
    static var appName: String = "MyApp"    // the name of the app using this LogStore package

    static func setupLog() {
        // check for prior log data in the file system
        guard let data = try? Data(contentsOf: FileManager.logFileURL) else { return }
        
        // decode the log data and prepare to add new entries to the log
        if let potentialLog = try? JSONDecoder().decode([LogEntry].self, from: data) {
            log = potentialLog
        }
    }
    
    static func writeLog() {
        // write the current log data to the file system, in the background
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(log)
                try data.write(to: FileManager.logFileURL, options: .atomicWrite)
            } catch {
                printLog("write log error: \(error)")
            }
        }
    }
}

extension FileManager {
    static var logFileURL: URL {
        // construct a url (aka path) for the log file
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            fatalError("Log file URL contruction failed!")
        }
        
        return url.appendingPathComponent("log")
    }
}

public func setLoggingAppName(_ string: String) {
    LogStore.appName = string
}

// a globally available function to print to the debug console & add an entry to the log array
public func printLog(_ string: String) {
    // print to the console
    print(string)
    
    // create a log entry using current date & time and add it to the log
    let entry = LogEntry(entryText: string, entryTime: Date())
    LogStore.log.append(entry)
    
    // try to save the log to file
    LogStore.writeLog()
}
