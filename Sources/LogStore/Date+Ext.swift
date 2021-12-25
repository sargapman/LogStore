//
//  Date+Ext.swift
//
//
//  Created by Monty Boyer on 12/24/21.
//  Derived from Simon Ng @ AppCoda
//

import Foundation

extension Date {
   
   // get a time of day string from a Date.  formatted as HH:MMam/pm
   static func todFromDate(date: Date) -> String {
      var todString = ""
      let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
      
      var minuteString = String(timeComponents.minute!)
      if minuteString.count == 1 {
         minuteString = "0" + minuteString
      }

      if timeComponents.hour! > 11 {
         todString = String(timeComponents.hour!-12) + ":" + minuteString + "pm"
      } else {
         todString = String(timeComponents.hour!) + ":" + minuteString + "am"
      }
      return(todString)
   }
   
   // get a date & time string from a Date, adjusted for timezone!  result is formatted as "MMM dd at HH:mm AM/PM"
   static func adjustedDateAndTimeStringFromDate(date: Date, returneGMT: Bool) -> String {
      var adjustedDate = date

      if returneGMT {
         // get the timezone from the date
         let dateComponents = Calendar.current.dateComponents([.timeZone], from: date)
         
         // get the time difference from GMT
         let secondsfromGMT = (dateComponents.timeZone!.secondsFromGMT())  // as Int
         // print("\(String(describing: secondsfromGMT))")

         // adjust the date for the timezone
         adjustedDate = Calendar.current.date(byAdding: .second, value: secondsfromGMT, to: date)!
      }
      
      let adjustedDateComponents = Calendar.current.dateComponents([.day, .month, .timeZone], from: adjustedDate)

      var resultStr = " at " + todFromDate(date: adjustedDate)
      
      resultStr = resultStr + " " + (adjustedDateComponents.timeZone?.abbreviation())!
      
      let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
      let monthName = months[adjustedDateComponents.month!-1]

      resultStr = "\(monthName) \(adjustedDateComponents.day!)" + resultStr
      return(resultStr)
   }
   
}

