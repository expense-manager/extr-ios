//
//  SyncGroup.swift
//  Extr
//
//  Created by Zekun Wang on 11/19/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class SyncGroup {
    static let TAG = NSStringFromClass(SyncGroup.self)
    
    static func getAllGroups(success: @escaping ([RGroup]) -> (), failure: @escaping (Error) -> ()) {
        
        let groupEndpoint = EndpointBuilder()
            .method(.get)
            .path(.group)
            .build()
        
        NetworkRequest(endpoint: groupEndpoint)
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
                
                success(RGroup.map(dictionaries: results))
            })
    }
    
    static func getAllGroupsByUserId(userId: String, success: @escaping ([RGroup]) -> (), failure: @escaping (Error) -> ()) {
        
        var userIdDict: [String: String] = [:]
        userIdDict["__type"] = "Pointer"
        userIdDict["className"] = "_User"
        userIdDict["objectId"] = userId
        
        let whereDict = ["where": ["userId": userIdDict]]
        
        let groupEndpoint = EndpointBuilder()
            .method(.get)
            .path(.group)
            .parameters(parameters: whereDict as [String : AnyObject])
            .build()
        
        NetworkRequest(endpoint: groupEndpoint)
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
                
                success(RGroup.map(dictionaries: results))
            })
    }
    
    static func getGroupById(groupId: String, success: @escaping (RGroup) -> (), failure: @escaping (Error) -> ()) {
        let groupEndpoint = EndpointBuilder()
            .method(.get)
            .path(.group)
            .appendIdToPath(groupId)
            .build()
        
        NetworkRequest(endpoint: groupEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                guard let result = response as? NSDictionary else {
                    let error = JsonError.noKey(key: "response")
                    failure(error)
                    return
                }
                
                success(RGroup.map(dictionary: result))
            })
    }
    
    static func create(group: RGroup, success: @escaping (RGroup) -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String : AnyObject] = [:]
        parameters[RGroup.JsonKey.groupname] = group.groupname as AnyObject
        parameters[RGroup.JsonKey.name] = group.name as AnyObject
        parameters[RGroup.JsonKey.about] = group.about as AnyObject
        parameters[RGroup.JsonKey.weeklyBudget] = String(group.weeklyBudget) as AnyObject
        parameters[RGroup.JsonKey.monthlyBudget] = String(group.monthlyBudget) as AnyObject
        
        var userIdDict: [String: String] = [:]
        userIdDict["__type"] = "Pointer"
        userIdDict["className"] = "_User"
        userIdDict["objectId"] = group.userId
        parameters[RGroup.JsonKey.userId] = userIdDict as AnyObject
        
        let groupEndpoint = EndpointBuilder()
            .method(.post)
            .path(.group)
            .parameters(parameters: parameters)
            .build()
        
        NetworkRequest(endpoint: groupEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                guard let result = response as? NSDictionary else {
                    let error = JsonError.noKey(key: "response")
                    failure(error)
                    return
                }
                
                success(RGroup.map(dictionary: result))
            })
    }
    
    static func update(group: RGroup, success: @escaping (RGroup) -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String : AnyObject] = [:]
        parameters[RGroup.JsonKey.groupname] = group.groupname as AnyObject
        parameters[RGroup.JsonKey.name] = group.name as AnyObject
        parameters[RGroup.JsonKey.about] = group.about as AnyObject
        parameters[RGroup.JsonKey.weeklyBudget] = String(group.weeklyBudget) as AnyObject
        parameters[RGroup.JsonKey.monthlyBudget] = String(group.monthlyBudget) as AnyObject
        
        let groupEndpoint = EndpointBuilder()
            .method(.put)
            .path(.group)
            .appendIdToPath(group.id)
            .parameters(parameters: parameters)
            .build()
        
        NetworkRequest(endpoint: groupEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                guard let result = response as? NSDictionary else {
                    let error = JsonError.noKey(key: "response")
                    failure(error)
                    return
                }
                
                success(RGroup.map(dictionary: result))
            })
    }
    
    static func delete(groupId: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let groupEndpoint = EndpointBuilder()
            .method(.delete)
            .path(.group)
            .appendIdToPath(groupId)
            .build()
        
        NetworkRequest(endpoint: groupEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                print("delete reponse; \(response)")
                guard let results = response as? NSDictionary else {
                    print("\(TAG): response - \(response)")
                    return
                }
                RGroup.deleteById(id: groupId)
                
                success(results)
            })
    }
}
