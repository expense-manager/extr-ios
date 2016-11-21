//
//  Helpers.swift
//  Extr
//
//  Created by Zekun Wang on 11/21/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class Helpers {
    static func getMonthDayYear(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
}
