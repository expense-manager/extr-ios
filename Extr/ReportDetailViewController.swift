//
//  ReportDetailViewController.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/30/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import CarbonKit

class ReportDetailViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    
    static let PIE_CHART: Int = 0
    static let BAR_CHART: Int = 1
    
    var requestCode: Int = 0
    var dates: [Date] = []
    var userId: String!
    var groupId: String!
    
    let reportDetailPagerViewControllerString = "ReportDetailPagerViewController"
    
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
        
        navigationItems = ["Categories", "Expenses"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: navigationItems as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        self.applyStyle()
    }
    
    func applyStyle() {
        let indicatorColor = UIColor.white//.withAlphaComponent(0.8)
        self.navigationController!.navigationBar.tintColor = UIColor.white
        carbonTabSwipeNavigation.toolbar.isTranslucent = false
        carbonTabSwipeNavigation.setIndicatorColor(indicatorColor)
        
        let screenSize: CGRect = UIScreen.main.bounds
        for i in 0 ..< 2 {
            carbonTabSwipeNavigation.carbonSegmentedControl!.setWidth(screenSize.width/2.0, forSegmentAt: i)
        }
        
        carbonTabSwipeNavigation.carbonSegmentedControl!.backgroundColor = AppConstants.cyan
        carbonTabSwipeNavigation.setNormalColor(UIColor.white.withAlphaComponent(0.6))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 14))
    }
    
    
    //MARK: - CarbonTabSwipeNavigationDelegate
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let reportDetailPagerViewController = storyBoard.instantiateViewController(withIdentifier: reportDetailPagerViewControllerString) as! ReportDetailPagerViewController
        reportDetailPagerViewController.requestCode = requestCode
        reportDetailPagerViewController.dates = dates
        
        switch index {
        case 0: reportDetailPagerViewController.chartType = ReportDetailViewController.PIE_CHART
        case 1: reportDetailPagerViewController.chartType = ReportDetailViewController.BAR_CHART
        default:reportDetailPagerViewController.chartType = ReportDetailViewController.PIE_CHART
        }
        
        return reportDetailPagerViewController
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
    
    }
    
}
