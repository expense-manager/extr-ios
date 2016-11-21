//
//  Endpoint.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation
import Alamofire

class Endpoint {
    var path: String
    var method: HTTPMethod
    var parameters: [String: AnyObject]
    var useToken: Bool
    
    convenience init(path: String, method: HTTPMethod, parameters: [String: AnyObject]) {
        self.init(path: path, method: method, parameters: parameters, useToken: false)
    }
    
    init(path: String, method: HTTPMethod, parameters: [String: AnyObject], useToken: Bool) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.useToken = useToken
    }
    
    func description() -> String {
        return "\n path: \(self.path)\n method: \(self.method.rawValue)\n parameters: \(self.parameters)\n"
    }
}
