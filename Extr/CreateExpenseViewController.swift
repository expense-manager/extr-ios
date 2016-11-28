//
//  CreateExpenseViewController.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/27/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CreateExpenseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        
        
        let navItem = UINavigationItem(title: "");
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CreateExpenseViewController.cancel))
        let doneItem = UIBarButtonItem(title: "Post", style: .done, target: nil, action: #selector(CreateExpenseViewController.post))
        
        navItem.leftBarButtonItem = cancelItem
        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        
        self.view.addSubview(navBar);
    }
    
    func post() {
        
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Must set View controller-based status bar appearance to NO in Info.plist
        // to use isStatusBarHidden
        UIApplication.shared.isStatusBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        super.viewWillDisappear(animated)
    }

}
