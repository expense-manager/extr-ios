//
//  MemberListViewController.swift
//  Extr
//
//  Created by Zekun Wang on 12/4/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let memberListSectionHeaderString = "MemberListSectionHeader"
    let memberCellString = "MemberCell"
    
    var userId: String!
    var groupId: String!
    var members: [RMember] = [] {
        didSet {
            headerInfos = []
            if members.count == 0 {
                return
            }
            
            for i in 0..<members.count {
                let curUser = RUser.getUserById(id: members[i].userId)
                let curChar = String(curUser!.fullname[curUser!.fullname.startIndex]).capitalized
        
                if i > 0 {
                    let preUser = RUser.getUserById(id: members[i - 1].userId)
                    let preChar = String(preUser!.fullname[preUser!.fullname.startIndex]).capitalized
                    if curChar == preChar {
                        headerInfos[headerInfos.count - 1].count += 1
                        continue
                    }
                }
                
                headerInfos.append(HeaderInfo(name: curChar, prevCount: i))
            }
            
            for info in headerInfos {
                print(info.toString())
            }
            invalidateViews()
        }
    }
    var headerInfos: [HeaderInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: self.memberCellString, bundle: nil), forCellReuseIdentifier: self.memberCellString)
        tableView.register(UINib(nibName: self.memberListSectionHeaderString, bundle: nil), forHeaderFooterViewReuseIdentifier: self.memberListSectionHeaderString)
        
        setNavigationBar()
        loadData()
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func loadData() {
        let userDefaults = UserDefaults.standard
        userId = userDefaults.string(forKey: RMember.JsonKey.userId)
        groupId = userDefaults.string(forKey: RMember.JsonKey.groupId)
        if groupId == nil {
            print("no group saved")
            return
        }
        
        members = Array(RMember.getMembersByGroupId(groupId: groupId).sorted(by: { (m1: RMember, m2: RMember) -> Bool in
            let user1 = RUser.getUserById(id: m1.userId)
            let user2 = RUser.getUserById(id: m2.userId)
            
            if user1 == nil {
                return false
            } else if user2 == nil {
                return true
            } else {
                return user1!.fullname < user2!.fullname
            }
        }))
        print("members count \(members.count)")
        SyncMember.getAllMembersByGroupId(groupId: groupId, success: { (members: [RMember]) -> () in
            self.members = members.sorted(by: { (m1: RMember, m2: RMember) -> Bool in
                let user1 = RUser.getUserById(id: m1.userId)
                let user2 = RUser.getUserById(id: m2.userId)
                
                if user1 == nil {
                    return false
                } else if user2 == nil {
                    return true
                } else {
                    return user1!.fullname < user2!.fullname
                }
            })
            print("sync members count \(self.members.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    func invalidateViews() {
        tableView.reloadData()
    }
    
    // MARK - TableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerInfos.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerInfos[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: memberListSectionHeaderString) as! MemberListSectionHeader
        header.headerInfo = headerInfos[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: memberCellString, for: indexPath) as! MemberCell
        let idx = headerInfos[indexPath.section].prevCount + indexPath.row
        cell.member = members[idx]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO - Go to member account detail
        tableView.deselectRow(at: indexPath, animated: true)
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
