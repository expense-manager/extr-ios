//
//  ReportViewController.swift
//  Extr
//
//  Created by Zekun Wang on 12/6/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let items = ["Weekly", "Monthly", "Yearly"]
//        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
//        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        
        setNavigationBar()
    }
    
//    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
//        return UIViewController()
//        // TODO - implement report lists
//    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = AppConstants.cyan
        navigationController?.navigationBar.tintColor = UIColor.white
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
