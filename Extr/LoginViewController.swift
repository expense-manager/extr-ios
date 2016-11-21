//
//  LoginViewController.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/15/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    static let TAG = NSStringFromClass(LoginViewController.self)
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 4
        loginButton.layer.borderColor = UIColor.white.cgColor
        loginButton.layer.borderWidth = 1
     
        loginButton.addTarget(self, action: #selector(loginButtonOnClick), for: .touchUpInside)
    }

    func loginButtonOnClick(sender: AnyObject) {
        if !isValid() {
            return
        }
        
        dismissSoftKeyboard()
        
        SyncUser.login(username: emailTextField.text!, password: passwordTextField.text!, success: { (dictionary: NSDictionary) -> () in
            print("\(type(of: self).TAG): \(dictionary)")
            self.saveUserData(dictionary: dictionary)
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    func isValid() -> Bool {
        // Todo: handle invalidate credentials
        return true
    }
    
    func saveUserData(dictionary: NSDictionary) {
        let user = RUser.map(dictionary: dictionary)
        
        if let sessionToken = dictionary[RUser.JsonKey.sessionToken] as? String {
            let userDefault = UserDefaults.standard
            userDefault.set(sessionToken, forKey: RUser.JsonKey.sessionToken)
            userDefault.set(user.id, forKey: RUser.JsonKey.objectId)
            userDefault.synchronize()
        } else {
            print("\(type(of: self).TAG): No session token.")
        }
        
        performSegue(withIdentifier: "LoginExpenseViewControllerSegue", sender: self)
    }
    
    func dismissSoftKeyboard() {
        view.endEditing(true)
    }
}
