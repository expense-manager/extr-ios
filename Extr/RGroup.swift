//
//  RGroup.swift
//  Extr
//
//  Created by Zekun Wang on 11/13/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation
import RealmSwift

class RGroup: Object {
    static let TAG = NSStringFromClass(RGroup.self)
    
    struct JsonKey {
        static let objectId = "objectId"
        static let groupname = "groupname"
        static let name = "name"
        static let about = "about"
        static let userId = "userId"
        static let weeklyBudget = "weeklyBudget"
        static let monthlyBudget = "monthlyBudget"
        static let createdAt = "createdAt"
    }
    
    struct PropertyKey {
        static let id = "id"
        static let groupname = "groupname"
        static let name = "name"
        static let about = "about"
        static let userId = "userId"
        static let weeklyBudget = "weeklyBudget"
        static let monthlyBudget = "monthlyBudget"
        static let createdAt = "createdAt"
    }
    
    dynamic var id: String = ""
    dynamic var groupname: String = ""
    dynamic var name: String = ""
    dynamic var about: String = ""
    dynamic var userId: String = ""
    dynamic var createdAt: Date = Date()
    dynamic var color: String = ""
    dynamic var weeklyBudget: Double = 0.0
    dynamic var monthlyBudget: Double = 0.0
    
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
        
        guard let createdAtString = dictionary[JsonKey.createdAt] as? String else {
            throw JsonError.noKey(key: JsonKey.createdAt)
        }
        
        self.id = id
        self.groupname = dictionary[JsonKey.groupname] as! String
        self.name = dictionary[JsonKey.name] as! String
        
        if let about = dictionary[JsonKey.about] as? String {
            self.about = about
        }
        
        if let weeklyBudget = dictionary[JsonKey.weeklyBudget] as? String {
            self.weeklyBudget = Double(weeklyBudget)!
        }
        
        if let monthlyBudget = dictionary[JsonKey.monthlyBudget] as? String {
            self.monthlyBudget = Double(monthlyBudget)!
        }
        
        self.userId = userIdDict[JsonKey.objectId] as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let createdAt = dateFormatter.date(from: createdAtString) {
            self.createdAt = createdAt
        } else {
            print("\(type(of: self).TAG): Error in parsing createdAt. createdAt: \(createdAtString)")
        }
        
        // TODO - get random color at creation
        //    // Get a random unused color
        //    this.color = Helpers.getRandomColor(null);
    }
    
    static func map(dictionaries: [NSDictionary]) -> [RGroup] {
        let realm = AppDelegate.getInstance().realm!
        var groups: [RGroup] = []
        
        for dictionary in dictionaries {
            let group = RGroup()
            
            do {
                try group.map(dictionary: dictionary)
                
                realm.beginWrite()
                realm.add(group, update: true)
                try realm.commitWrite()
                
                groups.append(group)
            } catch JsonError.noKey(let key) {
                let error = JsonError.noKey(key: key).error
                print("\(TAG): \(error.localizedDescription)")
            } catch let error {
                realm.cancelWrite()
                print("\(TAG): \(error)")
            }
        }
        
        return groups
    }
    
    static func map(dictionary: NSDictionary) -> RGroup {
        let realm = AppDelegate.getInstance().realm!
        let group = RGroup()
        
        do {
            try group.map(dictionary: dictionary)
            
            realm.beginWrite()
            realm.add(group, update: true)
            try realm.commitWrite()
            
        } catch JsonError.noKey(let key) {
            let error = JsonError.noKey(key: key).error
            print("\(TAG): \(error.localizedDescription)")
        } catch let error {
            realm.cancelWrite()
            print("\(TAG): \(error)")
        }
        
        return group
    }
    
    // MARK: - Realm queries
    static func getAllGroups() -> Results<RGroup> {
        let realm = AppDelegate.getInstance().realm!
        return realm.objects(RGroup.self).sorted(byProperty: PropertyKey.name, ascending: true)
    }
    
    static func getGroupById(id: String) -> RGroup? {
        let realm = AppDelegate.getInstance().realm!
        let predicate = NSPredicate(format:"\(PropertyKey.id) == %@", id)
        return realm.objects(RGroup.self).filter(predicate).first
    }

    static func deleteById(id: String) {
        let realm = AppDelegate.getInstance().realm!
        let group = getGroupById(id: id)
        if group != nil {
            realm.delete(group!)
        }
    }
}
