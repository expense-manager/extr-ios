//
//  MemberFilterViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/28/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class MemberFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let memberCell = "MemberCell"
    var expenseViewController: ExpenseViewController!
    var userId: String!
    var groupId: String!
    var members: [RMember] = [] {
        didSet {
            invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: memberCell, bundle: nil), forCellReuseIdentifier: memberCell)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
        
        //self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func invalidateViews() {
        if viewIfLoaded == nil {
            return
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        let userDefault = UserDefaults.standard
        self.userId = userDefault.string(forKey: RMember.JsonKey.userId)
        self.groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        
        if self.groupId == nil {
            print("no group saved")
            return
        }
        
        members = Array(RMember.getMembersByGroupId(groupId: self.groupId).sorted(by: { (m1: RMember, m2: RMember) -> Bool in
            let user1 = RUser.getUserById(id: m1.userId)
            let user2 = RUser.getUserById(id: m2.userId)
            
            if user1 == nil {
                return false
            }
            if user2 == nil {
                return true
            }
            return user1!.fullname < user2!.fullname
        }))
        print("members count \(members.count)")
        SyncMember.getAllMembersByGroupId(groupId: self.groupId, success: { (members: [RMember]) -> () in
            self.members = members.sorted(by: { (m1: RMember, m2: RMember) -> Bool in
                let user1 = RUser.getUserById(id: m1.userId)
                let user2 = RUser.getUserById(id: m2.userId)
                
                if user1 == nil {
                    return false
                }
                if user2 == nil {
                    return true
                }
                return user1!.fullname < user2!.fullname
            })
            print("caategories count: \(self.members.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.memberCell, for: indexPath) as! MemberCell
        cell.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        cell.member = members[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expenseViewController?.setFilters(member: members[indexPath.row], category: nil, startDate: nil, endDate: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
