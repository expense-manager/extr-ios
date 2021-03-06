//
//  SyncUser.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/15/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class SyncUser {
    static let TAG = NSStringFromClass(SyncUser.self)
    
    static func login(username: String, password: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        let loginEndpoint = EndpointBuilder()
            .method(.get)
            .path(.login)
            .parameters(key: RUser.JsonKey.username, value: username as AnyObject)
            .parameters(key: RUser.JsonKey.password, value: password as AnyObject)
            .build()
        
        NetworkRequest(endpoint: loginEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                print("login response: \(response)")
                guard let results = response as? NSDictionary else {
                    print("\(TAG): response - \(response)")
                    return
                }
                
                success(results)
            })
    }
    
    static func signUp(email: String, password: String, firstname: String, lastname: String, phone: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        var params: [String: AnyObject] = [:]
        params[RUser.JsonKey.username] = email as AnyObject
        params[RUser.JsonKey.password] = password as AnyObject
        params[RUser.JsonKey.firstName] = firstname as AnyObject
        params[RUser.JsonKey.lastName] = lastname as AnyObject
        params[RUser.JsonKey.photo] = phone as AnyObject
        
        let signUpEndpoint = EndpointBuilder()
            .method(.post)
            .path(.users)
            .parameters(parameters: params)
            .build()
        
        NetworkRequest(endpoint: signUpEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                
                guard let results = response as? NSDictionary else {
                    print("\(TAG): response - \(response)")
                    return
                }
                
                success(results)
            })

    }
    
    static func logout(success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        let logoutEndpoint = EndpointBuilder()
            .method(.post)
            .path(.logout)
            .build()
        
        NetworkRequest(endpoint: logoutEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                
                guard let results = response as? NSDictionary else {
                    print("\(TAG): response - \(response)")
                    return
                }
                
                success(results)
            })
        
    }
    
    static func getLoginUser(success: @escaping (RUser) -> (), failure: @escaping (Error) -> ()) {
        let logoutEndpoint = EndpointBuilder()
            .method(.get)
            .path(.loginUser)
            .useToken(true)
            .build()
        
        NetworkRequest(endpoint: logoutEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                print("login user: \(response)")
                guard let result = response as? NSDictionary else {
                    let error = JsonError.noKey(key: "response")
                    failure(error)
                    return
                }
                
                if result["error"] == nil {
                    let error = JsonError.noKey(key: "response")
                    failure(error)
                    return
                }
                
                success(RUser.map(dictionary: result))
            })
        
    }
}
