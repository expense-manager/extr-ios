//
//  SyncExpense.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation

class SyncExpense {
    static let TAG = NSStringFromClass(SyncExpense.self)
    
    static let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        
        queue.name = TAG
        queue.qualityOfService = .background
        queue.maxConcurrentOperationCount = 3
        
        return queue
    }()
    
    static func getAllExpenses(success: @escaping ([RExpense]) -> (), failure: @escaping (Error) -> ()) {
        
        let includeKeys = RExpense.JsonKey.userId + "," + RExpense.JsonKey.categoryId
        
        let expenseEndpoint = EndpointBuilder()
            .method(.get)
            .path(.expense)
            .parameters(key: "include", value: includeKeys)
            .build()
        
        NetworkRequest(endpoint: expenseEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                
                guard let results = response?["results"] as? [NSDictionary] else {
                    let error = JsonError.noKey(key: "results")
                    failure(error)
                    return
                }
                
                success(RExpense.map(dictionaries: results))
            })
    }
    
    static func getAllExpensesByUserId(userId: String, success: @escaping ([RExpense]) -> (), failure: @escaping (Error) -> ()) {
        
        let whereDict = ["where": PointerType.user.pointerFrom(id: userId)]
        let includeKeys = RExpense.JsonKey.categoryId
        
        let expenseEndpoint = EndpointBuilder()
            .method(.get)
            .path(.expense)
            .parameters(parameters: whereDict as [String : AnyObject])
            .parameters(key: "include", value: includeKeys as AnyObject)
            .build()
        
        NetworkRequest(endpoint: expenseEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                
                guard let results = response?["results"] as? [NSDictionary] else {
                    let error = JsonError.noKey(key: "results")
                    failure(error)
                    return
                }
                
                success(RExpense.map(dictionaries: results))
            })
    }
    
    static func getAllExpensesByGroupId(groupId: String, success: @escaping ([RExpense]) -> (), failure: @escaping (Error) -> ()) {
        
        let whereDict = ["where": PointerType.group.pointerFrom(id: groupId)]
        let includeKeys = RExpense.JsonKey.userId + "," + RExpense.JsonKey.categoryId
        
        let categoryEndpoint = EndpointBuilder()
            .method(.get)
            .path(.expense)
            .parameters(parameters: whereDict)
            .parameters(key: "include", value: includeKeys)
            .build()
        
        NetworkRequest(endpoint: categoryEndpoint)
            .run(completionHandler: { (response: AnyObject?, error: NSError?) in
                
                if error != nil {
                    failure(error!)
                    return
                }
                
                guard let results = response?["results"] as? [NSDictionary] else {
                    print("\(TAG): \(response)")
                    let error = JsonError.noKey(key: "results")
                    failure(error)
                    return
                }
                
                success(RExpense.map(dictionaries: results))
            })
    }
    
    static func create(amount: String, expenseDate: Date, note: String, imageData: Data?, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        var parameters:[String: Any] = [:]
        
        parameters[RExpense.JsonKey.amount] = amount
        parameters[RExpense.JsonKey.note] = note
        
        var spentAtDict:[String: Any] = ["__type": "Date"]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        spentAtDict[RExpense.JsonKey.iso] = "\(dateFormatter.string(from: expenseDate))"
        parameters[RExpense.JsonKey.spentAt] = spentAtDict
        
        let userDefault = UserDefaults.standard
        let userId = userDefault.string(forKey: RMember.JsonKey.userId)
        let groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        
        let createExpenseEndpoint = EndpointBuilder()
            .path(.expense)
            .method(.post)
            .parameters(parameters: parameters)
            .appendPointer(id: userId!, pointerType: .user)
            .appendPointer(id: groupId!, pointerType: .group)
            .build()
       
        var expenseId: String? = nil
        var fileName: String? = nil
        
        let createExpensePhotoOperation = BlockOperation {
            print("createExpensePhotoOperation start...")
            
            guard let id = expenseId, let name = fileName else {
                print("Invalid expenseId or fileName. expenseId:\(expenseId); fileName:\(fileName)")
                return
            }
            
            self.createExpensePhoto(expenseId: id, fileName: name, success: {(dictionary: NSDictionary) -> () in
                print("createExpensePhotoOperation: \(dictionary)")
            }, failure: { (error: Error) -> () in
                // TODO: Handle error properly
                print("createExpensePhotoOperation error:\(error)")
            })
        }
        
        let uploadPhotoOperation = BlockOperation {
            print("uploadPhotoOperation start...")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            
            SyncPhoto.upload(name: "\(dateFormatter.string(from: Date())).jpg", data: imageData!, success: { (dictionary: NSDictionary) -> () in
                fileName = dictionary["name"] as? String
                
                print("uploadPhotoOperation complete. dictionary:\(dictionary), fileName:\(fileName)")
                self.operationQueue.addOperation(createExpensePhotoOperation)
            }, failure: {(error: Error) -> () in
                // TODO: Handle error properly
                print("uploadPhotoOperation error:\(error)")
            })
        }
        
        let createExpenseOperation = BlockOperation {
            print("createExpenseOperation start...")
            
            NetworkRequest(endpoint: createExpenseEndpoint)
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
                    
                    expenseId = result[RExpense.JsonKey.objectId] as? String
                    print("createExpenseOperation complete. result:\(result), expenseId:\(expenseId)")
                    
                    if imageData != nil {
                        self.operationQueue.addOperation(uploadPhotoOperation)
                    }
                    
                    success(result)
                })
        }
        
        self.operationQueue.addOperation(createExpenseOperation)
    }
    
    static func createExpensePhoto(expenseId: String, fileName: String, success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()) {
        
        var parameters: [String: Any] = [:]
        
        // Build file pointer
        var filePointer: [String: Any] = [:]
        filePointer["__type"] = "File"
        filePointer["name"] = fileName
        parameters["photo"] = filePointer
        
        let createExpensePhotoEndpoint = EndpointBuilder()
            .path(.expensePhoto)
            .method(.post)
            .parameters(parameters: parameters)
            .appendPointer(id: expenseId, pointerType: .expense)
            .build()
        
        let createExpensePhotoOperation = BlockOperation() {
            NetworkRequest(endpoint: createExpensePhotoEndpoint)
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
        
        self.operationQueue.addOperation(createExpensePhotoOperation)
    }
}
