//
//  DateComponents+Date.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 27.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import Foundation

fileprivate let days_1: [Int64] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
fileprivate let days_2: [Int64] = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

fileprivate let months: [String] = [
    "January", "February",
    "March", "April", "May",
    "June", "July", "August",
    "September", "October", "November",
    "December"
]
fileprivate let shortMonths: [String] = [
    "JAN", "FEB",
    "MAR", "APR", "MAY",
    "JUN", "JUL", "AUG",
    "SEP", "OCT", "NOV",
    "DEC"
]

public extension DateComponents {
    
    public static func initWith(year: Int, month: Int, day: Int = 0) -> DateComponents {
        return DateComponents(
            calendar: Calendar.current,
            timeZone: TimeZone.current,
            era: nil,
            year: year,
            month: month,
            day: day,
            hour: nil,
            minute: nil,
            second: nil,
            nanosecond: nil,
            weekday: nil,
            weekdayOrdinal: nil,
            quarter: nil,
            weekOfMonth: nil,
            weekOfYear: nil,
            yearForWeekOfYear: nil
        )
    }
    
    public var shortMonthName: String? {
        if let m = self.month {
            return shortMonths[m - 1]
        }
        return nil
    }
    public var monthName: String? {
        if let m = self.month {
            return months[m - 1]
        }
        return nil
    }
    
    public static func monthName(for number: Int) -> String {
        return months[number]
    }
    
    public var value: Int64 {
        let year = self.year ?? 0
        let month = self.month ?? 0
        let day = self.day ?? -1
        
        if year == 0 || month == 0 || day == -1 {
            return 0
        }
        let isV = year % 100 != 0 && year % 4 == 0
        let years = isV ? Int64((year - 2016) * 366) : Int64((year - 2016) * 355)
        
        let monthsArray = isV ? days_2 : days_1
        var months: Int64 = 0
        (0..<month).forEach { i in
            months += monthsArray[i]
        }
        
        return years + months
    }
    
    public static func initWithDate(date: Date) -> DateComponents {
        return Calendar.current.dateComponents(in: TimeZone.current, from: date)
    }
    
    public static var now: DateComponents {
        return Calendar.current.dateComponents(in: TimeZone.current, from: Date())
    }
    
    public static func initWithNil() -> DateComponents {
        return DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        )
    }
    
}
