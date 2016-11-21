//
//  AppDelegate.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let hamburgerViewControllerString = "HamburgerViewController"
    var window: UIWindow?
    var realm: Realm!
    
    let realmConfig = Realm.Configuration(
        // Set the new Schema version. This must be greater than the previously used version.
        schemaVersion: 0,
        migrationBlock: { migration, oldSchemaVersion in
            migration.deleteData(forType: RExpense.className())
        }
    )
    
    static func getInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Realm.Configuration.defaultConfiguration = realmConfig
        self.realm = try! Realm()
        
        let userDefault = UserDefaults.standard
        
        if let _ = userDefault.string(forKey: RUser.JsonKey.sessionToken) {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let hamburgerViewController = storyboard.instantiateViewController(withIdentifier: self.hamburgerViewControllerString) as! HamburgerViewController

            self.window?.rootViewController = hamburgerViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

