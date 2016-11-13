//
//  RCategory.swift
//  Extr
//
//  Created by Zekun Wang on 11/13/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import Foundation
import RealmSwift

class RCategory: Object {
    static let TAG = NSStringFromClass(RCategory.self)
    
    struct JsonKey {
        static let objectId = "objectId"
        static let name = "name"
        static let color = "color"
        static let userId = "userId"
        static let groupId = "groupId"
        static let icon = "icon"
    }
    
    struct PropertyKey {
        static let id = "id"
        static let name = "name"
        static let color = "color"
        static let userId = "userId"
        static let groupId = "groupId"
        static let icon = "icon"
    }
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var color: String = ""
    dynamic var userId: String = ""
    dynamic var groupId: String = ""
    dynamic var icon: String = ""
    
    override static func primaryKey() -> String? {
        return PropertyKey.id
    }
    
    func map(dictionary: NSDictionary) throws {
        guard let id = dictionary[JsonKey.objectId] as? String else {
            throw JsonError.noKey(key: JsonKey.objectId)
        }
        
        guard let name = dictionary[JsonKey.name] as? String else {
            throw JsonError.noKey(key: JsonKey.name)
        }
        
        guard let color = dictionary[JsonKey.color] as? String else {
            throw JsonError.noKey(key: JsonKey.color)
        }
        
        guard let icon = dictionary[JsonKey.icon] as? String else {
            throw JsonError.noKey(key: JsonKey.icon)
        }
        
        guard let userIdDict = dictionary[JsonKey.userId] as? NSDictionary else {
            throw JsonError.noKey(key: JsonKey.userId)
        }
        
        guard let groupIdDict = dictionary[JsonKey.groupId] as? NSDictionary else {
            throw JsonError.noKey(key: JsonKey.groupId)
        }
        
        self.id = id
        self.name = name
        self.color = color
        self.icon = icon
        self.userId = userIdDict[JsonKey.objectId] as! String
        self.groupId = groupIdDict[JsonKey.objectId] as! String
    }
    
    static func map(dictionaries: [NSDictionary]) -> [RCategory] {
        let realm = AppDelegate.getInstance().realm!
        var categories: [RCategory] = []
        
        for dictionary in dictionaries {
            let category = RCategory()
            
            do {
                try category.map(dictionary: dictionary)
                
                realm.beginWrite()
                realm.add(category, update: true)
                try realm.commitWrite()
                
                categories.append(category)
            } catch JsonError.noKey(let key) {
                let error = JsonError.noKey(key: key).error
                print("\(TAG): \(error.localizedDescription)")
            } catch let error {
                realm.cancelWrite()
                print("\(TAG): \(error)")
            }
        }
        
        return categories
    }
    
    // MARK: - Realm queries
    static func getAllCategories() -> Results<RCategory> {
        let realm = AppDelegate.getInstance().realm!
        return realm.objects(RCategory.self).sorted(byProperty: PropertyKey.name, ascending: true)
    }
    
    static func getCategoryById(id: String) -> RCategory? {
        let realm = AppDelegate.getInstance().realm!
        let predicate = NSPredicate(format:"\(PropertyKey.id) == %@", id)
        return realm.objects(RCategory.self).filter(predicate).first
    }
    
    static func getCategoriesByGroupId(groupId: String) -> Results<RCategory> {
        let realm = AppDelegate.getInstance().realm!
        let predicate = NSPredicate(format:"\(PropertyKey.groupId) == %@", groupId)
        return realm.objects(RCategory.self).filter(predicate).sorted(byProperty: PropertyKey.name, ascending: true)
    }
}
