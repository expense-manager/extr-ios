//
//  GroupViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/16/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let groupCellString = "GroupCell"
    
    @IBOutlet var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController!
    var menuViewController: MenuViewController!
    var userId: String!
    var groupId: String!
    var selectedIndexPath: IndexPath!
    var members: [RMember] = [] {
        didSet {
            invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
        
        self.tableView.register(UINib(nibName: self.groupCellString, bundle: nil), forCellReuseIdentifier: self.groupCellString)
        
        loadData()
        if members.count > 0 {
            saveGroup(indexPath: IndexPath(row: 0, section: 0))
        }
    }
    
    func invalidateViews() {
        if viewIfLoaded == nil {
            return
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        let userDefault = UserDefaults.standard
        userId = userDefault.string(forKey: RMember.JsonKey.userId)
        groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        if userId == nil {
            print("no userId saved")
            return
        }
        
        members = Array(RMember.getMembersByUserId(userId: userId)).sorted(by: { (member1: RMember, member2: RMember) -> Bool in
            let group1 = RGroup.getGroupById(id: member1.groupId)
            let group2 = RGroup.getGroupById(id: member2.groupId)
            if group1 == nil {
                return false
            }
            if group2 == nil {
                return true
            }
            return group1!.name < group2!.name
        })
        
        SyncMember.getAllMembersByUserId(userId: userId, success: { (members: [RMember]) -> () in
            self.members = members.sorted(by: { (member1: RMember, member2: RMember) -> Bool in
                let group1 = RGroup.getGroupById(id: member1.groupId)
                let group2 = RGroup.getGroupById(id: member2.groupId)
                if group1 == nil {
                    return false
                }
                if group2 == nil {
                    return true
                }
                return group1!.name < group2!.name
            })
            if self.selectedIndexPath == nil {
                self.saveGroup(indexPath: IndexPath(row: 0, section: 0))
            }
            print("members count: \(self.members.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.groupCellString, for: indexPath) as! GroupCell
        if selectedIndexPath != nil {
            cell.isChecked = selectedIndexPath.row == indexPath.row
        }
        cell.member = members[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hamburgerViewController?.closeGroup()
        self.tableView.deselectRow(at: indexPath, animated: true)
        saveGroup(indexPath: indexPath)
        // TODO: refresh current view in contrainerView
        menuViewController?.refreshCurrentMenuView()
    }
    
    func saveGroup(indexPath: IndexPath) {
        print("indexPath: \(indexPath.row)")
        self.selectedIndexPath = indexPath
        let groupId = members[indexPath.row].groupId
        let userDefaults = UserDefaults.standard
        userDefaults.set(groupId, forKey: RMember.JsonKey.groupId)
        userDefaults.synchronize()
        tableView.reloadData()
    }
    
}
