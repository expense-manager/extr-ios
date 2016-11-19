//
//  RMember.swift
//  Extr
//
//  Created by Zekun Wang on 11/13/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation
import RealmSwift

class RMember: Object {
    static let TAG = NSStringFromClass(RMember.self)
    
    struct JsonKey {
        static let objectId = "objectId"
        static let userId = "userId"
        static let groupId = "groupId"
        static let createdBy = "createdBy"
        static let isAccepted = "isAccepted"
        static let createdAt = "createdAt"
    }
    
    struct PropertyKey {
        static let id = "id"
        static let userId = "userId"
        static let groupId = "groupId"
        static let createdById = "createdById"
        static let isAccepted = "isAccepted"
        static let createdAt = "createdAt"
    }
    
    dynamic var id: String = ""
    dynamic var userId: String = ""
    dynamic var groupId: String = ""
    dynamic var createdById: String = ""
    dynamic var isAccepted: Bool = true
    dynamic var createdAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return PropertyKey.id
    }
    
    func map(dictionary: NSDictionary) throws {
        guard let id = dictionary[JsonKey.objectId] as? String else {
            throw JsonError.noKey(key: JsonKey.objectId)
        }
        
        guard let userIdDict = dictionary[JsonKey.userId] as? NSDictionary else {
            throw JsonError.noKey(key: JsonKey.userId)
        }
        
        guard let groupIdDict = dictionary[JsonKey.groupId] as? NSDictionary else {
            throw JsonError.noKey(key: JsonKey.groupId)
        }
        
        guard let createdByIdDict = dictionary[JsonKey.createdBy] as? NSDictionary else {
            throw JsonError.noKey(key: JsonKey.createdBy)
        }
        
        guard let createdAtString = dictionary[JsonKey.createdAt] as? String else {
            throw JsonError.noKey(key: JsonKey.createdAt)
        }
        
        self.id = id
        RUser.map(dictionary: userIdDict)
        self.userId = groupIdDict[JsonKey.objectId] as! String
        RGroup.map(dictionary: groupIdDict)
        self.groupId = groupIdDict[JsonKey.objectId] as! String
        RUser.map(dictionary: createdByIdDict)
        self.createdById = createdByIdDict[JsonKey.objectId] as! String
        self.isAccepted = dictionary[JsonKey.isAccepted] as! Bool
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let createdAt = dateFormatter.date(from: createdAtString) {
            self.createdAt = createdAt
        } else {
            print("\(type(of: self).TAG): Error in parsing createdAt. createdAt: \(createdAtString)")
        }
    }
    
    static func map(dictionaries: [NSDictionary]) -> [RMember] {
        let realm = AppDelegate.getInstance().realm!
        var members: [RMember] = []
        
        for dictionary in dictionaries {
            let member = RMember()
            
            do {
                try member.map(dictionary: dictionary)
                
                realm.beginWrite()
                realm.add(member, update: true)
                try realm.commitWrite()
                
                members.append(member)
            } catch JsonError.noKey(let key) {
                let error = JsonError.noKey(key: key).error
                print("\(TAG): \(error.localizedDescription)")
            } catch let error {
                realm.cancelWrite()
                print("\(TAG): \(error)")
            }
        }
        
        return members
    }
    
    static func map(dictionary: NSDictionary) -> RMember {
        let realm = AppDelegate.getInstance().realm!
        let member = RMember()
        
        do {
            try member.map(dictionary: dictionary)
            
            realm.beginWrite()
            realm.add(member, update: true)
            try realm.commitWrite()
            
        } catch JsonError.noKey(let key) {
            let error = JsonError.noKey(key: key).error
            print("\(TAG): \(error.localizedDescription)")
        } catch let error {
            realm.cancelWrite()
            print("\(TAG): \(error)")
        }
        
        return member
    }
    
    // MARK: - Realm queries
    static func getAllMembers() -> Results<RMember> {
        let realm = AppDelegate.getInstance().realm!
        return realm.objects(RMember.self).sorted(byProperty: PropertyKey.createdAt, ascending: true)
    }
    
    static func getMemberById(id: String) -> RMember? {
        let realm = AppDelegate.getInstance().realm!
        let predicate = NSPredicate(format:"\(PropertyKey.id) == %@", id)
        return realm.objects(RMember.self).filter(predicate).first
    }
    
    static func getMembersByGroupId(groupId: String) -> Results<RMember> {
        let realm = AppDelegate.getInstance().realm!
        let predicate = NSPredicate(format:"\(PropertyKey.groupId) == %@", groupId)
        return realm.objects(RMember.self).filter(predicate).sorted(byProperty: PropertyKey.createdAt, ascending: true)
    }
    
    static func deleteById(id: String) {
        let realm = AppDelegate.getInstance().realm!
        let member = getMemberById(id: id)
        if member != nil {
            realm.delete(member!)
        }
    }
}
