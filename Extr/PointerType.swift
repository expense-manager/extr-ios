//
//  PointerType.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/29/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

enum PointerType: String {
    case user = "_User"
    case group = "Group"
    case category = "Category"
    case expense = "Expense"
    
    func pointerFrom(id: String) -> [String: Any] {
        var pointer: [String: String] = [:]
        
        pointer["__type"] = "Pointer"
        pointer["className"] = self.rawValue
        pointer["objectId"] = id
        
        var pointerKey = ""
        switch self {
        case .user:
            pointerKey = "userId"
        case.group:
            pointerKey = "groupId"
        case .category:
            pointerKey = "categoryId"
        case .expense:
            pointerKey = "expenseId"
        }
        
        return [pointerKey: pointer]
    }
}
