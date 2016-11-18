//
//  SyncExpense.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class SyncExpense {
    static let TAG = NSStringFromClass(SyncExpense.self)
    
    static func getAllExpenses(success: @escaping ([RExpense]) -> (), failure: @escaping (Error) -> ()) {
        
        let expenseEndpoint = EndpointBuilder()
            .method(.get)
            .path(.expense)
            .parameters(key: "include", value: RExpense.JsonKey.userId as AnyObject)
            .build()
        
        NetworkRequest(endpoint: expenseEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                
                guard let results = response?["results"] as? [NSDictionary] else {
                    let error = JsonError.noKey(key: "results")
                    failure(error)
                    return
                }
                
                success(RExpense.map(array: results))
            })
    }
    
    static func getAllExpensesByUserId(userId: String, success: @escaping ([RExpense]) -> (), failure: @escaping (Error) -> ()) {
        
        var userIdDict: [String: String] = [:]
        userIdDict["__type"] = "Pointer"
        userIdDict["className"] = "_User"
        userIdDict["objectId"] = userId
        
        let whereDict = ["where": ["userId": userIdDict]]
        
        let expenseEndpoint = EndpointBuilder()
            .method(.get)
            .path(.expense)
            .parameters(parameters: whereDict as [String : AnyObject])
            .build()
        
        NetworkRequest(endpoint: expenseEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                
                guard let results = response?["results"] as? [NSDictionary] else {
                    let error = JsonError.noKey(key: "results")
                    failure(error)
                    return
                }
                
                success(RExpense.map(array: results))
            })
    }
}
