//
//  RUser.swift
//  Extr
//
//  Created by Zekun Wang on 11/13/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation
import RealmSwift

class RUser: Object {
    static let TAG = NSStringFromClass(RUser.self)
    
    struct JsonKey {
        static let objectId = "objectId"
        static let username = "username"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let phone = "phone"
        static let photo = "photo"
        static let url = "url"
        static let groupId = "groupId"
        static let createdAt = "createdAt"
        static let password = "password"
        static let sessionToken = "sessionToken"
    }
    
    struct PropertyKey {
        static let id = "id"
        static let username = "username"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let phone = "phone"
        static let createdAt = "createdAt"
    }
    
    dynamic var id: String = ""
    dynamic var username: String = ""
    dynamic var firstName: String = ""
    dynamic var lastName: String = ""
    dynamic var email: String = ""
    dynamic var phone: String = ""
    dynamic var photoUrl: String = ""
    dynamic var createdAt: Date = Date()
    
    var fullname: String! {
        return "\(self.firstName) \(self.lastName)"
    }
    
    override static func primaryKey() -> String? {
        return PropertyKey.id
    }
    
    func map(dictionary: NSDictionary) throws {
        guard let id = dictionary[JsonKey.objectId] as? String else {
            throw JsonError.noKey(key: JsonKey.objectId)
        }
        
        guard let username = dictionary[JsonKey.username] as? String else {
            throw JsonError.noKey(key: JsonKey.username)
        }
        
        guard let firstName = dictionary[JsonKey.firstName] as? String else {
            throw JsonError.noKey(key: JsonKey.firstName)
        }
        
        guard let lastName = dictionary[JsonKey.lastName] as? String else {
            throw JsonError.noKey(key: JsonKey.lastName)
        }
        
        guard let createdAtString = dictionary[JsonKey.createdAt] as? String else {
            throw JsonError.noKey(key: JsonKey.createdAt)
        }
        
        self.id = id
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        
        if let email = dictionary[JsonKey.email] as? String {
            self.email = email
        }
        
        if let phone = dictionary[JsonKey.phone] as? String {
            self.phone = phone
        }
        
        if let photo = dictionary[JsonKey.photo] as? NSDictionary {
            if let url = photo[JsonKey.url] as? String {
                self.photoUrl = url
            }
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let createdAt = dateFormatter.date(from: createdAtString) {
            self.createdAt = createdAt
        } else {
            print("\(type(of: self).TAG): Error in parsing createdAt. createdAt: \(createdAtString)")
        }
    }
    
    static func map(dictionaries: [NSDictionary]) -> [RUser] {
        let realm = AppDelegate.getInstance().realm!
        var users: [RUser] = []
        
        for dictionary in dictionaries {
            let user = RUser()
            
            do {
                try user.map(dictionary: dictionary)
                
                realm.beginWrite()
                realm.add(user, update: true)
                try realm.commitWrite()
                
                users.append(user)
            } catch JsonError.noKey(let key) {
                let error = JsonError.noKey(key: key).error
                print("\(TAG): \(error.localizedDescription)")
            } catch let error {
                realm.cancelWrite()
                print("\(TAG): \(error)")
            }
        }
        
        return users
    }
    
    static func map(dictionary: NSDictionary) -> RUser {
        let realm = AppDelegate.getInstance().realm!
        let user = RUser()
        
        do {
            try user.map(dictionary: dictionary)
            
            realm.beginWrite()
            realm.add(user, update: true)
            try realm.commitWrite()
            
        } catch JsonError.noKey(let key) {
            let error = JsonError.noKey(key: key).error
            print("\(TAG): \(error.localizedDescription)")
        } catch let error {
            realm.cancelWrite()
            print("\(TAG): \(error)")
        }
        
        return user
    }
    
    // MARK: - Realm queries
    static func getAllUsers() -> Results<RUser> {
        let realm = AppDelegate.getInstance().realm!
        return realm.objects(RUser.self).sorted(byProperty: PropertyKey.firstName, ascending: true)
    }
    
    static func getUserById(id: String) -> RUser? {
        let realm = AppDelegate.getInstance().realm!
        let predicate = NSPredicate(format:"\(PropertyKey.id) == %@", id)
        return realm.objects(RUser.self).filter(predicate).first
    }
}

