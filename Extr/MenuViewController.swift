//
//  MenuViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/15/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Kingfisher

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menuCellString = "MenuCell"
    let overviewViewControllerString = "OverviewViewController"
    let expenseViewControllerString = "ExpenseViewController"
    let groupDetailViewControllerString = "GroupDetailViewController"
    let settingsViewControllerString = "SettingsViewController"
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController! {
        didSet {
            if currentIndex != nil {
                hamburgerViewController?.containerViewController = viewControllers[currentIndex]
            }
        }
    }
    
    var user: RUser! {
        didSet {
            if let imageURL = user?.photoUrl {
                let url = URL(string: imageURL)!
                let resource = ImageResource(downloadURL: url, cacheKey: "\(imageURL)")
                self.profileImageView.kf.setImage(with: resource, placeholder: UIImage(named:"placeholder"), options: [.transition(.fade(0.2))])
            }
            
            nameLabel.text = user.fullname
            emailLabel.text = user.email
        }
    }
    
    var menuItems: [MenuItem] = [
        MenuItem(icon: UIImage(named: "home")!, label: "Overview"),
        MenuItem(icon: UIImage(named: "credit-card")!, label: "Expense"),
        MenuItem(icon: UIImage(named: "trending")!, label: "Report"),
        MenuItem(icon: UIImage(named: "group")!, label: "Group"),
        MenuItem(icon: UIImage(named: "notification")!, label: "Notifications"),
        MenuItem(icon: UIImage(named: "setting")!, label: "Settings")
    ]
    
    var viewControllers: [UIViewController] = []
    var currentIndex: Int!
    
    private var overviewViewController: OverviewViewController!
    private var expenseViewController: ExpenseViewController!
    private var reportViewController: OverviewViewController!   // Temporary
    private var groupDetailViewController: GroupDetailViewController!
    private var notificationViewController: OverviewViewController!   // Temporary
    private var settingsViewController: SettingsViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
        
        self.tableView.register(UINib(nibName: self.menuCellString, bundle: nil), forCellReuseIdentifier: self.menuCellString)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        overviewViewController = storyBoard.instantiateViewController(withIdentifier: self.overviewViewControllerString) as! OverviewViewController
        expenseViewController = storyBoard.instantiateViewController(withIdentifier: self.expenseViewControllerString) as! ExpenseViewController
        reportViewController = storyBoard.instantiateViewController(withIdentifier: self.overviewViewControllerString) as! OverviewViewController
        groupDetailViewController = storyBoard.instantiateViewController(withIdentifier: self.groupDetailViewControllerString) as! GroupDetailViewController
        notificationViewController = storyBoard.instantiateViewController(withIdentifier: self.overviewViewControllerString) as! OverviewViewController
        settingsViewController = storyBoard.instantiateViewController(withIdentifier: self.settingsViewControllerString) as! SettingsViewController
        
        viewControllers = [overviewViewController, expenseViewController, reportViewController, groupDetailViewController, notificationViewController, settingsViewController]
        
        loadCurrentUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        selectMenuItem(index: 0)
    }
    
    func loadCurrentUser() {
        let userDefaults = UserDefaults.standard
        let userId = userDefaults.string(forKey: RMember.JsonKey.userId)
        if userId != nil {
            self.user = RUser.getUserById(id: userId!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.menuCellString, for: indexPath) as! MenuCell
        cell.menuItem = menuItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectMenuItem(index: indexPath.row)
        hamburgerViewController?.closeMenu()
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func selectMenuItem(index: Int) {
        currentIndex = index
        hamburgerViewController?.containerViewController = viewControllers[index]
    }
    
    func refreshCurrentMenuView() {
        if currentIndex == nil {
            return
        }
        
//        viewControllers = [overviewViewController, expenseViewController, reportViewController, groupDetailViewController, notificationViewController, settingsViewController]
        switch(currentIndex) {
        case 0: break;  // overview
        case 1: expenseViewController.loadData()
        case 2: break;  // report
        case 3: break;  // group detail
        case 4: break;  // notification
        case 5: break;  // settings
        case 6: break;  // logout
        default: break
        }
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
