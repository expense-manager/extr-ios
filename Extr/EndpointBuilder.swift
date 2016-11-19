//
//  EndpointBuilder.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation
import Alamofire

class EndpointBuilder {
    static let TAG = NSStringFromClass(EndpointBuilder.self)
    
    enum Path: String {
        case login = "login"
        case logout = "logout"
        case users = "users"
        case expense = "classes/Expense"
        case category = "classes/Category"
        case group = "classes/Group"
        case member = "classes/Member"
        case expensePhoto = "classes/Photo"
        case loginUser = "users/me"
        case files = "files"
    }
    
    var path: String = ""
    var method: HTTPMethod = .get
    var parameters: [String: AnyObject] = [:]
    
    func path(_ path: Path) -> EndpointBuilder {
        self.path = path.rawValue
        return self
    }
    
    func appendIdToPath(_ id: String) -> EndpointBuilder {
        self.path += "/\(id)"
        return self
    }
    
    func method(_ method: HTTPMethod) -> EndpointBuilder {
        self.method = method
        return self
    }
    
    func parameters(key: String, value: AnyObject) -> EndpointBuilder {
        self.parameters[key] = value
        return self
    }
    
    func parameters(parameters: [String: AnyObject]) -> EndpointBuilder {
        self.parameters = parameters
        return self
    }
    
    func build() -> Endpoint {
        return Endpoint(path: self.path, method: self.method, parameters: self.parameters)
    }
}
