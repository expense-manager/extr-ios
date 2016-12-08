//
//  OverviewViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/20/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var containerView: UIView!
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var monthlyLabel: UILabel!
    @IBOutlet var monthlySpendableLabel: UILabel!
    @IBOutlet var weeklySpendableLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let expenseCellString = "ExpenseCell"
    let levelViewString = "LevelView"
    var hamburgerViewController: HamburgerViewController!
    var levelView: LevelView!
    
    var userId: String!
    var groupId: String!
    var group: RGroup!
    var amount: Double = 0
    var expenses: [RExpense] = [] {
        didSet {
            invalidateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("overview view controller viewDidLoad")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 62
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: expenseCellString, bundle: nil), forCellReuseIdentifier: expenseCellString)
        
        self.navigationController?.navigationBar.barTintColor = AppConstants.cyan
        self.view.backgroundColor = AppConstants.cyan_deep
        
        setUpCreateButton()
        addLevelView()
        
        let userDefaults = UserDefaults.standard
        userId = userDefaults.string(forKey: RMember.JsonKey.userId)
        groupId = userDefaults.string(forKey: RMember.JsonKey.groupId)
        syncData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
    }
    
    func invalidateViews() {
        tableView.reloadData()
    }
    
    func setUpCreateButton() {
        let screenSize = UIScreen.main.bounds
        
        let buttonSize: CGFloat = 60
        let button = CreateButton(frame: CGRect(x: screenSize.width / 2 - buttonSize / 2, y: screenSize.height - buttonSize * 3 / 2 - 44, width: buttonSize, height: buttonSize))
        button.crossPadding = 10
        view.addSubview(button)
        
        let createButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.createButtonAction(_:)))
        createButtonTapGesture.cancelsTouchesInView = false
        
        button.addGestureRecognizer(createButtonTapGesture)
    }
    
    func createButtonAction(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "CreateExpenseViewControllerSegue", sender: self)
    }
    
    func addLevelView() {
        let viewSize: CGFloat = 250
        levelView = LevelView(frame: CGRect(x: UIScreen.main.bounds.width / 2 - viewSize / 2, y: containerView.bounds.height / 2 - viewSize / 2, width: viewSize, height: viewSize))
        levelView.layer.borderWidth = 10
        levelView.layer.borderColor = UIColor.white.cgColor
        containerView.addSubview(levelView)
    }
    
    func resetData() {
        group = nil
        amount = 0
        expenses = []
    }
    
    func loadData() {
        let userDefaults = UserDefaults.standard
        userId = userDefaults.string(forKey: RMember.JsonKey.userId)
        groupId = userDefaults.string(forKey: RMember.JsonKey.groupId)
        
        if groupId == nil {
            print("No groupId saved")
            resetData()
            return
        }
        
        monthLabel.text = Helpers.getMonthOfYearString(date: Date())
        group = RGroup.getGroupById(id: groupId)
        if let group = group {
            amount = group.monthlyBudget
            monthlyLabel.text = "$" + Helpers.getFormattedAmount(amount: amount)
            monthlySpendableLabel.text = "$" + Helpers.getFormattedAmount(amount: amount)
            weeklySpendableLabel.text = "$" + Helpers.getFormattedAmount(amount: group.weeklyBudget)
        }
        
        let dates = Helpers.getMonthStartEndDate(date: Date())
        expenses = Array(RExpense.getExpensesByGroupId(groupId: groupId))
        for expense in RExpense.getExpensesByFiltersAndGroupId(groupId: groupId, member: nil, category: nil, startDate: dates[0], endDate: dates[1]) {
            amount -= expense.amount
        }
    
        let endPosition = group.monthlyBudget != 0 ? amount / group.monthlyBudget : 1
        toLevelPosition(endPosition: endPosition)
        monthlyLabel.text = "$" + Helpers.getFormattedAmount(amount: amount)
    }
    
    func syncData() {
        SyncExpense.getAllExpensesByGroupId(groupId: groupId, success: { (expenses: [RExpense]) -> () in
            self.loadData()
            print("expenses count: \(self.expenses.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    func toLevelPosition(endPosition: Double) {
        if endPosition > 1 || endPosition < 0 {
            return
        }
        
        levelView.endPosition = endPosition
        levelView.play()
        
        let time = levelView.fullTimeInSecond * endPosition
    }
    
    @IBAction func hamburgerIconTapped(_ sender: UIBarButtonItem) {
        hamburgerViewController?.isMenu = true
        hamburgerViewController?.attachGrayoutView()
        hamburgerViewController?.openMenu()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = expenses.count == 0
        return min(expenses.count, 3)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: expenseCellString, for: indexPath) as! ExpenseCell
        cell.expense = expenses[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO - go to detail page
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
