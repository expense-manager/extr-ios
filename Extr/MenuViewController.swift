//
//  MenuViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/15/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let menuCellString = "MenuCell"
    
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController!
    
    var user: RUser! {
        didSet {
            nameLabel.text = user.fullname
            emailLabel.text = user.email
        }
    }
    
    var menuItems: [MenuItem] = [
        MenuItem(icon: UIImage(named: "trending-up")!, label: "Overview"),
        MenuItem(icon: UIImage(named: "trending-up")!, label: "Expense"),
        MenuItem(icon: UIImage(named: "trending-up")!, label: "Report"),
        MenuItem(icon: UIImage(named: "trending-up")!, label: "Group")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
        
        self.tableView.register(UINib(nibName: self.menuCellString, bundle: nil), forCellReuseIdentifier: self.menuCellString)
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
        hamburgerViewController?.closeMenu()
        self.tableView.deselectRow(at: indexPath, animated: true)
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
