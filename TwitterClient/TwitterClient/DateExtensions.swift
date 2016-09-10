//
//  DateExtensions.swift
//  TwitterClient
//
//  Created by Michael Wasserman on 2016-09-10.
//  Copyright © 2016 Wasserman. All rights reserved.
//

import Foundation

extension NSDate {
    class func fromDateToString(dateToConvert:NSDate) -> String? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(dateToConvert)
        return dateString
    }
    
    class func stringToDate(dateStr:String) -> NSDate? {
        let dateFormatter        = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone   = NSTimeZone(name: "UTC")
        return dateFormatter.dateFromString(dateStr)
    }
}