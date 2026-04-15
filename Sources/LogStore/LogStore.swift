//
//  LogStore.swift
//  LogStore Package
//
//  Created by Monty Boyer on 5/4/20.
//  Copyright © 2020 Monty Boyer. All rights reserved.
//

import Foundation

struct LogEntry: Codable, Sendable {
   let entry: String
   let time: String
}

actor LogStore {
   static let shared = LogStore()

   var log: [LogEntry] = []
   var appName: String = "MyApp"
   var maxLogEntries: Int = 1000

   func setupLog() {
      // check for prior log data in the file system
      guard let data = try? Data(contentsOf: FileManager.logFileURL) else { return }
      
      // decode the log data and prepare to add new entries to the log
      if let potentialLog = try? JSONDecoder().decode([LogEntry].self, from: data) {
         log = potentialLog
      }
   }

   func writeLog() {
      // write the current log data to the file system
      do {
         let data = try JSONEncoder().encode(log)
         try data.write(to: FileManager.logFileURL, options: .atomicWrite)
      } catch {
         print("write log error: \(error)")
      }
   }

   func clearLog() {
      // clear the log array then write that to the file
      log = []
      writeLog()
   }

   func trimLogSize() {
      let overCount: Int = log.count - maxLogEntries
      if overCount > 0 {
         log.removeFirst(overCount)
      }
   }

   func addEntry(_ string: String, time: String) {
      let entry = LogEntry(entry: string, time: time)
      log.append(entry)
      trimLogSize()
      writeLog()
   }

   func getLog() -> [LogEntry] {
      return log
   }

   func getAppName() -> String {
      return appName
   }

   func setAppName(_ name: String) {
      appName = name
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
   Task {
      await LogStore.shared.setAppName(string)
   }
}

// a globally available function to print to the debug console & add an entry to the log array
public func printLog(_ string: String) {
   
   // conversion for the log entry time to a string
   let dateFormatter: DateFormatter = {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      return dateFormatter
   }()
   
   // print to the console
   print(string)
   
   // create a log entry using current date & time and add it to the log
   // Display timezone in more familiar terms, e.g. CST, PDT
   var commonTz = ""
   if #available(iOS 15.0, *) {
      commonTz = Date().formatted(.dateTime.timeZone())
   }

   let datetimeString = "\(dateFormatter.string(from: Date())) \(commonTz)"

   // add the entry to the log via the actor (thread-safe)
   Task {
      await LogStore.shared.addEntry(string, time: datetimeString)
   }
}
