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
    var path: String = ""
    var method: HTTPMethod = .get
    var parameters: [String: AnyObject] = [:]
    
    init(path: String, method: HTTPMethod, parameters: [String: AnyObject]) {
        self.path = path
        self.method = method
        self.parameters = parameters
    }
    
    func description() -> String {
        return "\n path: \(self.path)\n method: \(self.method.rawValue)\n parameters: \(self.parameters)\n"
    }
}
