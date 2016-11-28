//
//  CategoryViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/27/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    let categoryCell: String = "CategoryCell"
    var userId: String!
    var groupId: String!
    var categories: [RCategory] = [] {
        didSet {
            invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: categoryCell, bundle: nil), forCellReuseIdentifier: categoryCell)
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 62
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
        userId = userDefault.string(forKey: RMember.JsonKey.userId)
        groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        if groupId == nil {
            print("no group saved")
            return
        }
        
        categories = Array(RCategory.getCategoriesByGroupId(groupId: groupId))
        
        SyncCategory.getAllCategoriesByGroupId(groupId: groupId, success: { (categories: [RCategory]) -> () in
            self.categories = categories.sorted{ $0.0.name > $0.1.name }
            print("caategories count: \(self.categories.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCell, for: indexPath) as! CategoryCell
        
        cell.category = categories[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: perform detail segue
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
