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
    var members: [RMember]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTestData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
        
        self.tableView.register(UINib(nibName: self.groupCellString, bundle: nil), forCellReuseIdentifier: self.groupCellString)
        tableView.reloadData()
    }
    
    func addTestData() {
        let realm = AppDelegate.getInstance().realm!
        members = [RMember]()
        do {
            let member1 = RMember()
            let group1 = RGroup()
            group1.id = "ajaidf;oijafijeoa;"
            group1.name = "testGroupName"
            member1.groupId = group1.id
            
            let member2 = RMember()
            let group2 = RGroup()
            group2.id = "ejitojglfkdn;"
            group2.name = "anotherName"
            member2.id = "1fdjgei"
            member2.groupId = group2.id
            
            realm.beginWrite()
            realm.add(group1, update: true)
            realm.add(member1, update: true)
            
            realm.add(group2, update: true)
            realm.add(member2, update: true)
            try realm.commitWrite()
            
            members.append(member1)
            members.append(member2)
        } catch JsonError.noKey(let key) {
            let error = JsonError.noKey(key: key).error
            realm.cancelWrite()
        } catch let error {
            realm.cancelWrite()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members == nil ? 0 : members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.groupCellString, for: indexPath) as! GroupCell
        cell.member = members[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hamburgerViewController?.closeGroup()
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
