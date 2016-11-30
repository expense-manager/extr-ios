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
    var parameters: [String: Any]
    var data: Data?
    
    var headers = [
        "X-Parse-Application-Id": Secrets.applicationId,
        "X-Parse-Master-Key": Secrets.masterKey,
        ]
    
    convenience init(path: String, method: HTTPMethod, parameters: [String: Any]) {
        self.init(path: path, method: method, parameters: parameters, useToken: false, data: nil)
    }
    
    convenience init(path: String, method: HTTPMethod, parameters: [String: Any], useToken: Bool) {
        self.init(path: path, method: method, parameters: parameters, useToken: false, data: nil)
    }
    
    init(path: String, method: HTTPMethod, parameters: [String: Any], useToken: Bool, data: Data?) {
        self.path = path
        self.method = method
        self.parameters = parameters
        self.data = data
        
        if useToken {
            let userDefault = UserDefaults.standard
            headers["X-Parse-Session-Token"] = userDefault.string(forKey: RUser.JsonKey.sessionToken)
        }
        
        headers["Content-Type"] = self.data == nil ? "application/json" : "image/jpeg"
    }
    
    func description() -> String {
        return "\n headers: \(self.headers)\n path: \(self.path)\n method: \(self.method.rawValue)\n parameters: \(self.parameters)\n"
    }
}
