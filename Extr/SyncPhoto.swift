//
//  SyncPhoto.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/29/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class SyncPhoto {
    static let TAG = NSStringFromClass(SyncPhoto.self)
    
    static func upload(name: String, data: Data, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        var parameters:[String: Any] = [:]
        parameters["CONTENT"] = data

        let uploadFileEndpoint = EndpointBuilder()
            .method(.post)
            .path(.files)
            .parameters(parameters: parameters)
            .appendData(data: data)
            .appendFileName(name)
            .build()

        NetworkRequest(endpoint: uploadFileEndpoint)
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
                
                success(result)
            })
    }
}
