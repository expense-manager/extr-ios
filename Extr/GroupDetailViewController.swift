//
//  GroupDetailViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/16/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class GroupDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //setupNavigationBar()
    }
    
    func setupNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        let navigationItem = UINavigationItem(title: "Group")
        navigationBar.backgroundColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
