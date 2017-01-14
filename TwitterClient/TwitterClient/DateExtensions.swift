//
//  DateExtensions.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import Foundation

extension Date {
    static func fromDateToString(_ dateToConvert:Date) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: dateToConvert)
        return dateString
    }
    
    static func stringToDate(_ dateStr:String) -> Date? {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone   = TimeZone(identifier: "UTC")
        return dateFormatter.date(from: dateStr)
    }
}
