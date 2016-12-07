//
//  TimeReportPagerCell.swift
//  Extr
//
//  Created by Zekun Wang on 12/7/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class TimeReportPagerCell: UITableViewCell {

    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    var amount: Double! {
        didSet {
            if amount == nil {
                amount = 0
            }
            amountLabel.text = "$" + Helpers.getFormattedAmount(amount: amount)
        }
    }
    var timeString: String! {
        didSet {
            timeLabel.text = self.timeString == nil ? "Invalid Date String" : self.timeString
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
