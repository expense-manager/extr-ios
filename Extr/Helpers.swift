//
//  Helpers.swift
//  Extr
//
//  Created by Zekun Wang on 11/21/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class Helpers {
    static func getFormattedAmount(amount: Double) -> String {
        let newAmount = String(format: "%.2f", amount)
        print("new Amount: \(newAmount)")
        
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        let result = formatter.string(from: NSNumber(value: Double(newAmount)!))!
        print("result: \(result)")
        
        return result
    }
    
    static func getMonthDayYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    static func getReportWeeklyDateString(dates: [Date]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: dates[0]) + " - " + dateFormatter.string(from: dates[1])
    }
    
    static func getReportMonthlyDateString(dates: [Date]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM, yyyy"
        return dateFormatter.string(from: dates[0])
    }
    
    static func getReportYearlyDateString(dates: [Date]) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "'Year' yyyy"
        return dateFormatter.string(from: dates[0])
    }
    
    static func getExpenseItemDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy 'at' hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    static func getAllValidDates(groupId: String, rawDates: [[Date]]) -> [[Date]] {
        var dates: [[Date]] = []
        
        for date in rawDates {
            let expenses = RExpense.getExpensesByFiltersAndGroupId(groupId: groupId, member: nil, category: nil, startDate: date[0], endDate: date[1])
            if expenses.count > 0 {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    static func getAllValidYears(groupId: String) -> [[Date]] {
        let rawDates: [[Date]] = Helpers.getAllYears(groupId: groupId)
        var dates: [[Date]] = []
        
        for date in rawDates {
            let expenses = RExpense.getExpensesByFiltersAndGroupId(groupId: groupId, member: nil, category: nil, startDate: date[0], endDate: date[1])
            if expenses.count > 0 {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    static func getAllYears(groupId: String) -> [[Date]] {
        var rawDates: [[Date]] = []
        var startComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        guard let oldestExpense = RExpense.getOldestExpenseByGroupId(groupId: groupId) else {
            return rawDates
        }
        let endDate = oldestExpense.spentAt
        let endComponents = Calendar.current.dateComponents(in: .current, from: endDate)
        
        while startComponents.year! >= endComponents.year! {
            let startEnd = Helpers.getYearStartEndDate(date: Calendar.current.date(from: startComponents)!)
            print("getAllYears: year \(startEnd[0]) - \(startEnd[1])")
            rawDates.append(startEnd)
            startComponents.year! -= 1
        }
        
        return rawDates
    }
    
    static func getYearStartEndDate(date: Date) -> [Date] {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let startDate = Calendar.current.date(from: components)
        components.year! += 1
        components.month = 1
        components.day = 0
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = Calendar.current.date(from: components)
        return [startDate!, endDate!]
    }
    
    static func getAllValidMonths(groupId: String) -> [[Date]] {
        let rawDates: [[Date]] = Helpers.getAllMonths(groupId: groupId)
        var dates: [[Date]] = []
        
        for date in rawDates {
            let expenses = RExpense.getExpensesByFiltersAndGroupId(groupId: groupId, member: nil, category: nil, startDate: date[0], endDate: date[1])
            if expenses.count > 0 {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    static func getAllMonths(groupId: String) -> [[Date]] {
        var rawDates: [[Date]] = []
        var startComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        
        guard let oldestExpense = RExpense.getOldestExpenseByGroupId(groupId: groupId) else {
            return rawDates
        }
        let endDate = oldestExpense.spentAt
        let endComponents = Calendar.current.dateComponents(in: .current, from: endDate)
        
        while startComponents.year! > endComponents.year! || (startComponents.year! == endComponents.year! && startComponents.month! >= endComponents.month!) {
            let startEnd = Helpers.getMonthStartEndDate(date: Calendar.current.date(from: startComponents)!)
            print("getAllMonths: month \(startEnd[0]) - \(startEnd[1])")
            rawDates.append(startEnd)
            startComponents.month! -= 1
        }
        
        return rawDates
    }
    
    static func getMonthStartEndDate(date: Date) -> [Date] {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let startDate = Calendar.current.date(from: components)
        components.month! += 1
        components.day = 0
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = Calendar.current.date(from: components)
        return [startDate!, endDate!]
    }
    
    static func getAllValidWeeks(groupId: String) -> [[Date]] {
        let rawDates: [[Date]] = Helpers.getAllWeeks(groupId: groupId)
        var dates: [[Date]] = []
        
        for date in rawDates {
            let expenses = RExpense.getExpensesByFiltersAndGroupId(groupId: groupId, member: nil, category: nil, startDate: date[0], endDate: date[1])
            if expenses.count > 0 {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    static func getAllWeeks(groupId: String) -> [[Date]] {
        var rawDates: [[Date]] = []
        var startComponents = Calendar.current.dateComponents([.year, .month, .day, .weekOfYear, .weekday], from: Date())
        
        guard let oldestExpense = RExpense.getOldestExpenseByGroupId(groupId: groupId) else {
            return rawDates
        }
        let endDate = oldestExpense.spentAt
        let endComponents = Calendar.current.dateComponents(in: .current, from: endDate)
        
        while startComponents.year! > endComponents.year! || (startComponents.year! == endComponents.year! && startComponents.weekOfYear! >= endComponents.weekOfYear!) {
            let startEnd = Helpers.getWeekStartEndDate(date: Calendar.current.date(from: startComponents)!)
            print("getAllWeeks: week \(startEnd[0]) - \(startEnd[1])")
            rawDates.append(startEnd)
            startComponents.day! -= 7
            startComponents.weekOfYear! -= 1
        }
        
        return rawDates
    }
    
    static func getWeekStartEndDate(date: Date) -> [Date] {
        var components = Calendar.current.dateComponents([.year, .month, .day, .weekOfYear, .weekday], from: date)
        components.day! -= components.weekday! - 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        let startDate = Calendar.current.date(from: components)
        components.day! += 6
        components.hour = 23
        components.minute = 59
        components.second = 59
        let endDate = Calendar.current.date(from: components)
        return [startDate!, endDate!]
    }
}
