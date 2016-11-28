//
//  ExpenseViewController.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Alamofire

class ExpenseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    
    let expenseCell: String = "ExpenseCell"
    var userId: String!
    var groupId: String!
    var expenses: [RExpense] = [] {
        didSet {
            invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: expenseCell, bundle: nil), forCellReuseIdentifier: expenseCell)
        
        setUpCreateButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
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

        expenses = Array(RExpense.getExpensesByGroupId(groupId: groupId))

        SyncExpense.getAllExpensesByGroupId(groupId: groupId, success: { (expenses: [RExpense]) -> () in
            self.expenses = expenses.sorted{ $0.0.spentAt > $0.1.spentAt }
            print("expenses count: \(self.expenses.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //TODO: set up data for detail page.
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expenseCell, for: indexPath) as! ExpenseCell
        
        cell.expense = expenses[indexPath.row]
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: perform detail segue
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func setUpCreateButton() {
        let screenSize = UIScreen.main.bounds
        
        let buttonSize: CGFloat = 50
        let button = CreateButton(frame: CGRect(x: screenSize.width / 2 - buttonSize / 2, y: screenSize.height - buttonSize * 3 / 2, width: buttonSize, height: buttonSize))
        button.crossPadding = 10
        view.addSubview(button)
        
        let createButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.createButtonAction(_:)))
        createButtonTapGesture.cancelsTouchesInView = false
        
        button.addGestureRecognizer(createButtonTapGesture)
    }
    
    func createButtonAction(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "CreateExpenseViewControllerSegue", sender: self)
    }
    
}
