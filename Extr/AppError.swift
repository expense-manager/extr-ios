//
//  AppError.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case timeout
    case error(error: String)
    
    var error: NSError {
        switch self {
        case .timeout:
            return NSError(description: "Connect timeout.")
        default:
            return NSError(description: "Error.")
        }
    }
}

enum JsonError: Error {
    case noKey(key: String)
    
    var error: NSError {
        switch self {
        case .noKey(let key):
            return NSError(description: "No such a key: \(key).")
        }
    }
}

extension NSError {
    convenience init(domain: String = "AppErrorDomain", code: Int = -1, description: String) {
        var userInfo = [String: String]()
        userInfo[NSLocalizedDescriptionKey] = description;
        self.init(domain: "AppError", code: code, userInfo: userInfo)
    }
}
