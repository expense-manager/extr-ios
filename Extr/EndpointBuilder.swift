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
    
    let baseUrl = "https://e-manager.herokuapp.com/parse/"
    
    var path: String = ""
    var method: HTTPMethod = .get
    var parameters: [String: Any] = [:]
    var extraParameters: [String: Any] = [:]
    var useToken: Bool = false
    var data: Data?
    
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
    
    func parameters(key: String, value: Any) -> EndpointBuilder {
        self.parameters[key] = value as AnyObject
        return self
    }
    
    func useToken(_ useToken: Bool) -> EndpointBuilder {
        self.useToken = useToken
        return self
    }
    
    func parameters(parameters: [String: Any]) -> EndpointBuilder {
        self.parameters = parameters
        return self
    }
    
    func appendFileName(_ name: String) -> EndpointBuilder {
        self.path += "/\(name)"
        return self
    }
    
    func appendData(data: Data) -> EndpointBuilder {
        self.data = data
        return self
    }
    
    func build() -> Endpoint {
        parameters.merge(with: extraParameters)
        return Endpoint(path: baseUrl + path, method: method, parameters: parameters, useToken: useToken, data: data)
    }
    
    func appendPointer(id: String, pointerType: PointerType) -> EndpointBuilder {
        self.extraParameters.merge(with: pointerType.pointerFrom(id: id))
        return self
    }
    
    static func buildPointer(id: String, pointerType: PointerType) -> [String: String] {
        var pointer: [String: String] = [:]
        
        pointer["__type"] = "Pointer"
        pointer["className"] = pointerType.rawValue
        pointer["objectId"] = id
        
        return pointer
    }
    
}

extension Dictionary {
    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }
    
    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dict.merge(with: dictionary)
        return dict
    }
}
