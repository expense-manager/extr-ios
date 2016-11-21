//
//  NetworkRequest.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation
import Alamofire

class NetworkRequest {
    static let TAG = NSStringFromClass(NetworkRequest.self)
    
    let baseUrl = "https://e-manager.herokuapp.com/parse/"
    
    var headers = [
        "X-Parse-Application-Id": Secrets.applicationId,
        "X-Parse-Master-Key": Secrets.masterKey,
        "Content-Type": "application/json",
        ]
    
    var endpoint: Endpoint!
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
        if endpoint.useToken {
            let userDefault = UserDefaults.standard
            headers["X-Parse-Session-Token"] = userDefault.string(forKey: RUser.JsonKey.sessionToken)
        }
    }
    
    func run(completionHandler: @escaping (AnyObject?, NSError?) ->()) {
        print("\(type(of:self).TAG): endpoint \(self.endpoint.description())")
        
        Alamofire.request(baseUrl + endpoint.path, method: endpoint.method, parameters: endpoint.parameters, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    completionHandler(value as AnyObject?, nil)
                case .failure(let error):
                    completionHandler(nil, error as NSError?)
                }
        }
    }
}
