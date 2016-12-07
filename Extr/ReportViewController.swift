//
//  ReportViewController.swift
//  Extr
//
//  Created by Zekun Wang on 12/6/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import CarbonKit

class ReportViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    static let WEEKLY: Int = 0
    static let MONTHLY: Int = 1
    static let YEARLY: Int = 2
    
    let reportPagerListViewControllerString = "ReportPagerListViewController"
    
    var hamburgerViewController: HamburgerViewController!
    var navigationItems = NSArray()
    var carbonTabSwipeNavigation: CarbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize tab bar item
//        self.tabBarItem.tag = 0
//        self.tabBarItem.title = ""
//        self.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState())
//        self.tabBarItem.selectedImage = UIImage(named: "")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
//        self.tabBarItem.image = UIImage(named: "")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItems = ["Weekly", "Monthly", "Yearly"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: navigationItems as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        self.applyStyle()
        
        setNavigationBar()
    }
    
    func applyStyle() {
        let indicatorColor = UIColor.white//.withAlphaComponent(0.8)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(indicatorColor)
        
        let screenSize: CGRect = UIScreen.main.bounds
        for i in 0 ..< 3 {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(screenSize.width/3.0, forSegmentAt: i)
        }
        
        carbonTabSwipeNavigation.carbonSegmentedControl!.backgroundColor = AppConstants.cyan
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
        
//        carbonTabSwipeNavigation.carbonSegmentedControl!.selectedSegmentIndex = 1
    }
        

    //MARK: - CarbonTabSwipeNavigationDelegate
        
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let reportPagerListViewController = storyBoard.instantiateViewController(withIdentifier: reportPagerListViewControllerString) as! ReportPagerListViewController
        switch index {
        case 0: reportPagerListViewController.requestCode = ReportViewController.WEEKLY
        case 1: reportPagerListViewController.requestCode = ReportViewController.MONTHLY
        case 2: reportPagerListViewController.requestCode = ReportViewController.YEARLY
        default:reportPagerListViewController.requestCode = ReportViewController.WEEKLY
        }
        
        return reportPagerListViewController
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = AppConstants.cyan
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    @IBAction func hamburgerIconTapped(_ sender: UIBarButtonItem) {
        hamburgerViewController?.isMenu = true
        hamburgerViewController?.attachGrayoutView()
        hamburgerViewController?.openMenu()
    }

}
