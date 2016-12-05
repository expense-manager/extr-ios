//
//  HeaderInfo.swift
//  Extr
//
//  Created by Zekun Wang on 12/4/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class HeaderInfo {
    var name: String
    var count: Int
    var prevCount: Int
    
    init(name: String, count: Int = 1, prevCount: Int) {
        self.name = name
        self.count = count
        self.prevCount = prevCount
    }
    
    func toString() -> String {
        return name + " : count - " + String(count) + " prevCount - " + String(prevCount)
    }
}
