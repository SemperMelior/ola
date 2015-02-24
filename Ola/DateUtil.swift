//
//  DateUtil.swift
//  Ola
//
//  Created by Lucille Benoit on 2/19/15.
//  Copyright (c) 2015 cs147. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    func getCurrentTime() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        var stringValue = formatter.stringFromDate(date)
        return stringValue
    }
    func getCurrentDate() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        var stringValue = formatter.stringFromDate(date)
        return stringValue
    }
   
}
