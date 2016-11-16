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
                
                guard let results = response as? NSDictionary else {
                    print("\(TAG): response - \(response)")
                    return
                }
                
                success(results)
            })
    }
}
