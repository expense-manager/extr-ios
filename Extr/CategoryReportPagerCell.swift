//
//  CategoryReportPagerCell.swift
//  Extr
//
//  Created by Zekun Wang on 12/7/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CategoryReportPagerCell: UITableViewCell {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    var amount: Double! {
        didSet {
            if amount == nil {
                amount = 0
            }
            amountLabel.text = "$" + Helpers.getFormattedAmount(amount: amount)
        }
    }
    
    var category: RCategory! {
        didSet {
            if let category = category {
                nameLabel.text = category.name
                backgroundImageView.backgroundColor = UIColor.HexToColor(hexString: category.color)
                iconImageView.isHidden = false
                iconImageView.image = UIImage(named: category.icon)?.withRenderingMode(.alwaysTemplate)
            } else {
                nameLabel.text = "No Category"
                backgroundImageView.backgroundColor = UIColor.lightGray
                iconImageView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImageView.layer.cornerRadius = 20
        backgroundImageView.clipsToBounds = true
        iconImageView.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
