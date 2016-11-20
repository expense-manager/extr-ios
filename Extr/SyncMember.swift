//
//  SyncMember.swift
//  Extr
//
//  Created by Zekun Wang on 11/19/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class SyncMember {
    static let TAG = NSStringFromClass(SyncMember.self)
    
    static func getAllMembers(success: @escaping ([RMember]) -> (), failure: @escaping (Error) -> ()) {
        
        let includeKeys = RMember.JsonKey.userId + "," + RMember.JsonKey.createdBy + "," + RMember.JsonKey.groupId
        
        let memberEndpoint = EndpointBuilder()
            .method(.get)
            .path(.member)
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: memberEndpoint)
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
                
                success(RMember.map(dictionaries: results))
            })
    }
    
    static func getAllMembersByUserId(userId: String, success: @escaping ([RMember]) -> (), failure: @escaping (Error) -> ()) {
        
        var userIdDict: [String: String] = [:]
        userIdDict["__type"] = "Pointer"
        userIdDict["className"] = "_User"
        userIdDict["objectId"] = userId

        let whereDict = ["where": [RMember.JsonKey.userId: userIdDict]]
        let includeKeys = RMember.JsonKey.userId + "," + RMember.JsonKey.createdBy + "," + RMember.JsonKey.groupId
        
        let memberEndpoint = EndpointBuilder()
            .method(.get)
            .path(.member)
            .parameters(parameters: whereDict as [String : AnyObject])
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: memberEndpoint)
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
                
                success(RMember.map(dictionaries: results))
            })
    }
    
    static func getAllMembersByGroupId(groupId: String, success: @escaping ([RMember]) -> (), failure: @escaping (Error) -> ()) {
        
        var groupIdDict: [String: String] = [:]
        groupIdDict["__type"] = "Pointer"
        groupIdDict["className"] = "Group"
        groupIdDict["objectId"] = groupId
        
        let whereDict = ["where": [RMember.JsonKey.groupId: groupIdDict]]
        let includeKeys = RMember.JsonKey.userId + "," + RMember.JsonKey.createdBy + "," + RMember.JsonKey.groupId
        
        let memberEndpoint = EndpointBuilder()
            .method(.get)
            .path(.member)
            .parameters(parameters: whereDict as [String : AnyObject])
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: memberEndpoint)
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
                
                success(RMember.map(dictionaries: results))
            })
    }
    
    static func getMemberById(memberId: String, success: @escaping (RMember) -> (), failure: @escaping (Error) -> ()) {
        let includeKeys = RMember.JsonKey.userId + "," + RMember.JsonKey.createdBy + "," + RMember.JsonKey.groupId
        let memberEndpoint = EndpointBuilder()
            .method(.get)
            .path(.member)
            .appendIdToPath(memberId)
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: memberEndpoint)
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
                
                success(RMember.map(dictionary: result))
            })
    }
    
    static func create(member: RMember, success: @escaping (RMember) -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String : AnyObject] = [:]
        parameters[RMember.JsonKey.isAccepted] = member.isAccepted as AnyObject
        
        var userIdDict: [String: String] = [:]
        userIdDict["__type"] = "Pointer"
        userIdDict["className"] = "_User"
        userIdDict["objectId"] = member.userId
        parameters[RMember.JsonKey.userId] = userIdDict as AnyObject
        
        var groupIdDict: [String: String] = [:]
        groupIdDict["__type"] = "Pointer"
        groupIdDict["className"] = "Group"
        groupIdDict["objectId"] = member.groupId
        parameters[RMember.JsonKey.groupId] = groupIdDict as AnyObject
        
        var createdByIdDict: [String: String] = [:]
        createdByIdDict["__type"] = "Pointer"
        createdByIdDict["className"] = "_User"
        createdByIdDict["objectId"] = member.createdById
        parameters[RMember.JsonKey.createdBy] = createdByIdDict as AnyObject
        
        let includeKeys = RMember.JsonKey.userId + "," + RMember.JsonKey.createdBy + "," + RMember.JsonKey.groupId
        parameters["include"] = includeKeys as AnyObject
        
        let groupEndpoint = EndpointBuilder()
            .method(.post)
            .path(.member)
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
                
                success(RMember.map(dictionary: result))
            })
    }
    
    static func update(member: RMember, success: @escaping (RMember) -> (), failure: @escaping (Error) -> ()) {
        var parameters: [String : AnyObject] = [:]
        parameters[RMember.JsonKey.isAccepted] = member.isAccepted as AnyObject
        
        let includeKeys = RMember.JsonKey.userId + "," + RMember.JsonKey.createdBy + "," + RMember.JsonKey.groupId
        parameters["include"] = includeKeys as AnyObject
        
        let groupEndpoint = EndpointBuilder()
            .method(.put)
            .path(.member)
            .appendIdToPath(member.id)
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
                
                success(RMember.map(dictionary: result))
            })
    }
    
    static func delete(memberId: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let memberEndpoint = EndpointBuilder()
            .method(.delete)
            .path(.member)
            .appendIdToPath(memberId)
            .build()
        
        NetworkRequest(endpoint: memberEndpoint)
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
                RMember.deleteById(id: memberId)
                
                success(results)
            })
    }
}
