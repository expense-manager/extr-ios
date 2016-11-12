//
//  ExpenseViewController.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Alamofire

class ExpenseViewController: UIViewController {
    
    var expenses: [RExpense] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SyncExpense.getAllExpenses(success: { (expenses: [RExpense]) -> () in
            self.expenses = expenses.sorted{ $0.0.spentAt > $0.1.spentAt }
            print("expenses count: \(self.expenses.count)")
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
}
