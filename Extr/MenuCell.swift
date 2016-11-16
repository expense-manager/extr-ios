//
//  MenuCell.swift
//  Extr
//
//  Created by Zekun Wang on 11/15/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var iconLabel: UILabel!
    
    var menuItem: MenuItem! {
        didSet {
            iconImageView.image = menuItem.icon.withRenderingMode(.alwaysTemplate)
            iconLabel.text = menuItem.label
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.tintColor = UIColor(red:0.38, green:0.46, blue:0.51, alpha:1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
