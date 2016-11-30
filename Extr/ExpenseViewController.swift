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
    let dateFilterViewString = "DateFilterView"
    let memberFilterViewControllerString = "MemberFilterViewController"
    let categoryFilterViewControllerString = "CategoryFilterViewController"
    
    var hamburgerViewController: HamburgerViewController!
    var member: RMember?
    var category: RCategory?
    var startDate: Date?
    var endDate: Date?
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
        
        syncData()
        setUpCreateButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setNeedsStatusBarAppearanceUpdate()
        
        loadData()
        showFilters()
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

        expenses = Array(RExpense.getExpensesByFiltersAndGroupId(groupId: groupId, member: member, category: category, startDate: startDate, endDate: endDate))
    }
    
    func syncData() {
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
    
    func showFilters() {
        let alertController = UIAlertController(title: "Filters", message: "", preferredStyle: .actionSheet)
        let allAction = UIAlertAction(title: "All", style: .default) { (action) in
            print("all action")
            self.member = nil
            self.category = nil
            self.startDate = nil
            self.endDate = nil
            
            self.loadData()
        }
        let categoryAction = UIAlertAction(title: "Category", style: .default) { (action) in
            print("category action")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let categoryFilterViewController = storyBoard.instantiateViewController(withIdentifier: self.categoryFilterViewControllerString) as! CategoryFilterViewController
            categoryFilterViewController.expenseViewController = self
            categoryFilterViewController.selectedCategory = self.category
            self.present(categoryFilterViewController, animated: true, completion: nil)
        }
        let dateAction = UIAlertAction(title: "Date", style: .default) { (action) in
            print("date action")
            self.showDate()
        }
        let memberAction = UIAlertAction(title: "Member", style: .default) { (action) in
            print("member action")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let memberFilterViewController = storyBoard.instantiateViewController(withIdentifier: self.memberFilterViewControllerString) as! MemberFilterViewController
            memberFilterViewController.expenseViewController = self
            self.present(memberFilterViewController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(allAction)
        alertController.addAction(categoryAction)
        alertController.addAction(dateAction)
        alertController.addAction(memberAction)
        alertController.addAction(cancelAction)
        // TODO: - show filter options when click navigation bar
        hamburgerViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func showDate() {
        let grayoutView = UIView(frame: UIScreen.main.bounds)
        grayoutView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let dateFilterView = UINib(nibName: dateFilterViewString, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DateFilterView
        dateFilterView.expenseViewController = self
        dateFilterView.grayoutView = grayoutView
        dateFilterView.startDate = startDate
        dateFilterView.endDate = endDate
        let screenBounds = UIScreen.main.bounds
        dateFilterView.center = CGPoint(x: screenBounds.width / 2, y: screenBounds.height / 2)
        self.view.addSubview(grayoutView)
        self.view.addSubview(dateFilterView)
    }
    
    func setMemberFilter(member: RMember?) {
        self.member = member
        self.loadData()
    }
    
    func setCategoryFilter(category: RCategory?) {
        self.category = category
        self.loadData()
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
