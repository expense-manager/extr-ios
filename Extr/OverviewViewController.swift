//
//  OverviewViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/20/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("overview view controller viewDidLoad")
        
        self.navigationController?.navigationBar.barTintColor = AppConstants.cyan
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hamburgerIconTapped(_ sender: UIBarButtonItem) {
        hamburgerViewController?.isMenu = true
        hamburgerViewController?.attachGrayoutView()
        hamburgerViewController?.openMenu()
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
