//
//  DateFormatComponent.swift
//  TheMovieDB
//
//  Created by Arthur Augusto Sousa Marques on 3/13/18.
//  Copyright © 2018 Arthur Augusto. All rights reserved.
//

extension Date {
    var day: Int { return Calendar.current.component(.day, from: self) }
    var weekday: Int { return Calendar.current.component(.weekday, from: self) }
    var month: Int { return Calendar.current.component(.month, from: self) }
    var year: Int { return Calendar.current.component(.year, from: self) }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else {
            return 0
        }
        
        return end - start
    }
    
    func isGreaterThan(date: Date) -> Bool {
        var isGreater = false
        
        if compare(date) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        return isGreater
    }
    
    func isEarlierThan(date: Date) -> Bool {
        var isEarlier = false
        
        if compare(date) == ComparisonResult.orderedAscending {
            isEarlier = true
        }
        
        return isEarlier
    }
    
    func equalsTo(date: Date) -> Bool {
        var isEqualTo = false
        
        if compare(date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        return isEqualTo
    }
    
    var isToday: Bool {
        return equalsTo(date: Date().dateFor(.startOfDay))
    }
    
    func addDateComponent(_ component: Calendar.Component, units: Int) -> Date {
        var components = DateComponents()
        components.setValue(units, for: component)
        let newDate = Calendar.current.date(byAdding: components, to: self)!
        return newDate
    }
    
    func addDays(_ daysToAdd: Int) -> Date {
        return addDateComponent(.day, units: daysToAdd)
    }
    
    func addMonths(_ monthsToAdd: Int) -> Date {
        return addDateComponent(.month, units: monthsToAdd)
    }
    
    func addYears(_ yearsToAdd: Int) -> Date {
        return addDateComponent(.year, units: yearsToAdd)
    }
    
    func addHours(_ hoursToAdd: Int) -> Date {
        return addDateComponent(.hour, units: hoursToAdd)
    }
    
    func addMinutes(_ minutesToAdd: Int) -> Date {
        return addDateComponent(.minute, units: minutesToAdd)
    }
    
    func addSeconds(_ secondsToAdd: Int) -> Date {
        return addDateComponent(.second, units: secondsToAdd)
    }
    
    func yearsFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.year, from: date, to: self, options: []).year!
    }
    
    func monthsFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.month, from: date, to: self, options: []).month!
    }
    
    func weeksFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.weekOfYear, from: date, to: self, options: []).weekOfYear!
    }
    
    func daysFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.day, from: date, to: self, options: []).day!
    }
    
    func hoursFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.hour, from: date, to: self, options: []).hour!
    }
    
    func minutesFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.minute, from: date, to: self, options: []).minute!
    }
    
    func secondsFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.second, from: date, to: self, options: []).second!
    }
    
    func nanosecondsFrom(_ date:Date) -> Int {
        return (Calendar.current as NSCalendar).components(.nanosecond, from: date, to: self, options: []).second!
    }
    
    func previousMonth(_ count: Int) -> Date? {
        return Calendar.current.date(byAdding: .month, value: count * -1, to: self)
    }
    
    func offsetFrom(_ date:Date) -> String {
        if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
        if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
        if weeksFrom(date)   > 0 { return "\(weeksFrom(date))w"   }
        if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
        if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
        if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}
