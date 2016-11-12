//
//  ExpenseCell.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {

    @IBOutlet var amountLabel: UILabel!
    
    var expense: RExpense! {
        didSet {
            amountLabel.text = "\(expense.amount)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
