//
//  Date+.swift
//  Top100Albums
//
//  Created by Iree García on 26/09/20.
//

import Foundation

extension DateFormatter {
   convenience init(format: String) {
      self.init()
      dateFormat = format
      calendar = Calendar(identifier: .iso8601)
      timeZone = TimeZone(secondsFromGMT: 0)
      locale = Locale(identifier: "en_US_POSIX")
   }
   
   static let knownFormats = ["yyyy-MM-dd", "yyyy"]
   static let formatters = knownFormats.map(DateFormatter.init)
   
   static func knownFormatDate(from string: String) -> Date? {
      print(string)
      for (i, format) in knownFormats.enumerated() {
         // NOTE: simple approach for these formats. Regex is another option
         if string.count == format.count {
            return formatters[i].date(from: string)
         }
      }
      return nil
   }
}
