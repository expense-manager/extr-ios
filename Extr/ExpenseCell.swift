//
//  ExpenseCell.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/12/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Kingfisher

class ExpenseCell: UITableViewCell {

    @IBOutlet var cellContainerView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var expenseInfoView: UIView!
    @IBOutlet var spentAtLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categoryBackgroundImageView: UIImageView!
    @IBOutlet var categoryIconImageView: UIImageView!
    
    var expense: RExpense! {
        didSet {
            let user = RUser.getUserById(id: expense.userId)

            if let imageURL = user?.photoUrl {
                let url = URL(string: imageURL)!
                let resource = ImageResource(downloadURL: url, cacheKey: "\(imageURL)")
                self.profileImageView.kf.setImage(with: resource, placeholder: UIImage(named:"placeholder"), options: [.transition(.fade(0.2))])
            }
            
            spentAtLabel.text = Helpers.getExpenseItemDate(date: expense.spentAt)
            nameLabel.text = user?.fullname
            amountLabel.text = "$\(expense.amount)"
            
            let category = RCategory.getCategoryById(id: expense.categoryId)
            if let category = category {
                categoryLabel.text = category.name
                categoryBackgroundImageView.backgroundColor = UIColor.HexToColor(hexString: category.color)
                categoryIconImageView.isHidden = false
                categoryIconImageView.image = UIImage(named: category.icon)?.withRenderingMode(.alwaysTemplate)
            } else {
                categoryLabel.text = "No Category"
                categoryBackgroundImageView.backgroundColor = UIColor.lightGray
                categoryIconImageView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellContainerView.backgroundColor = AppConstants.cyan_deep
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        expenseInfoView.layer.cornerRadius = 5
        categoryBackgroundImageView.layer.cornerRadius = 18
        categoryIconImageView.tintColor = UIColor.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
