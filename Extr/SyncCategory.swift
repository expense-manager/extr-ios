//
//  SyncCategory.swift
//  Extr
//
//  Created by Zekun Wang on 11/19/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class SyncCategory {
    static let TAG = NSStringFromClass(SyncCategory.self)
    
    static func getAllCategories(success: @escaping ([RCategory]) -> (), failure: @escaping (Error) -> ()) {
        
        let includeKeys = RCategory.JsonKey.userId
        
        let categoryEndpoint = EndpointBuilder()
            .method(.get)
            .path(.category)
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: categoryEndpoint)
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
                
                success(RCategory.map(dictionaries: results))
            })
    }
    
    static func getAllCategoriesByUserId(userId: String, success: @escaping ([RCategory]) -> (), failure: @escaping (Error) -> ()) {
        
        var userIdDict: [String: String] = [:]
        userIdDict["__type"] = "Pointer"
        userIdDict["className"] = "_User"
        userIdDict["objectId"] = userId
        
        let whereDict = ["where": [RCategory.JsonKey.userId: userIdDict]]
        let includeKeys = RCategory.JsonKey.userId
        
        let categoryEndpoint = EndpointBuilder()
            .method(.get)
            .path(.category)
            .parameters(parameters: whereDict as [String : AnyObject])
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: categoryEndpoint)
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
                
                success(RCategory.map(dictionaries: results))
            })
    }
    
    static func getAllCategoriesByGroupId(groupId: String, success: @escaping ([RCategory]) -> (), failure: @escaping (Error) -> ()) {
        
        var groupIdDict: [String: String] = [:]
        groupIdDict["__type"] = "Pointer"
        groupIdDict["className"] = "Group"
        groupIdDict["objectId"] = groupId
        
        let whereDict = ["where": [RMember.JsonKey.groupId: groupIdDict]]
        let includeKeys = RMember.JsonKey.userId
        
        let categoryEndpoint = EndpointBuilder()
            .method(.get)
            .path(.category)
            .parameters(parameters: whereDict as [String : AnyObject])
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: categoryEndpoint)
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
                
                success(RCategory.map(dictionaries: results))
            })
    }
    
    static func create(category: RCategory, success: @escaping (RCategory) -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String : AnyObject] = [:]
        parameters[RCategory.JsonKey.name] = category.name as AnyObject
        parameters[RCategory.JsonKey.color] = category.color as AnyObject
        parameters[RCategory.JsonKey.icon] = category.icon as AnyObject
        
        var userIdDict: [String: String] = [:]
        userIdDict["__type"] = "Pointer"
        userIdDict["className"] = "_User"
        userIdDict["objectId"] = category.userId
        parameters[RMember.JsonKey.userId] = userIdDict as AnyObject
        
        var groupIdDict: [String: String] = [:]
        groupIdDict["__type"] = "Pointer"
        groupIdDict["className"] = "Group"
        groupIdDict["objectId"] = category.groupId
        parameters[RMember.JsonKey.groupId] = groupIdDict as AnyObject
        
        let includeKeys = RMember.JsonKey.userId
        parameters["include"] = includeKeys as AnyObject
        
        let groupEndpoint = EndpointBuilder()
            .method(.post)
            .path(.category)
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
                
                success(RCategory.map(dictionary: result))
            })
    }
    
    static func update(category: RCategory, success: @escaping (RCategory) -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String : AnyObject] = [:]
        parameters[RCategory.JsonKey.name] = category.name as AnyObject
        parameters[RCategory.JsonKey.color] = category.color as AnyObject
        parameters[RCategory.JsonKey.icon] = category.icon as AnyObject
        
        let includeKeys = RMember.JsonKey.userId
        parameters["include"] = includeKeys as AnyObject
        
        let groupEndpoint = EndpointBuilder()
            .method(.put)
            .path(.category)
            .appendIdToPath(category.id)
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
                
                success(RCategory.map(dictionary: result))
            })
    }
    
    static func delete(categoryId: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let categoryEndpoint = EndpointBuilder()
            .method(.delete)
            .path(.category)
            .appendIdToPath(categoryId)
            .build()
        
        NetworkRequest(endpoint: categoryEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                print("delete reponse; \(response)")
                RCategory.deleteById(id: categoryId)
                
                success()
            })
    }
}
