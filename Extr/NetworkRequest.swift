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
    
    var endpoint: Endpoint!
    
    init(endpoint: Endpoint) {
        self.endpoint = endpoint
    }
    
    func run(completionHandler: @escaping (AnyObject?, NSError?) ->()) {
        print("\(type(of:self).TAG): endpoint \(self.endpoint.description())")
        
        if endpoint.data != nil {
            print("\(type(of:self).TAG): upload")
            
            Alamofire.upload(endpoint.data!, to: endpoint.path, method: endpoint.method, headers: endpoint.headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        completionHandler(value as AnyObject?, nil)
                    case .failure(let error):
                        completionHandler(nil, error as NSError?)
                    }
            }
        } else if endpoint.method == .get {
            print("\(type(of:self).TAG): \(endpoint.method)")
            
            Alamofire.request(endpoint.path, method: endpoint.method, parameters: endpoint.parameters, headers: endpoint.headers)
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        completionHandler(value as AnyObject?, nil)
                    case .failure(let error):
                        completionHandler(nil, error as NSError?)
                    }
            }
        } else if endpoint.method == .post || endpoint.method == .put || endpoint.method == .delete {
            print("\(type(of:self).TAG): \(endpoint.method)")
            
            Alamofire.request(endpoint.path, method: endpoint.method, parameters: endpoint.parameters, encoding: JSONEncoding.default, headers: endpoint.headers)
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

}
