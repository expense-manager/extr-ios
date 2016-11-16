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

    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var noteLabel: UILabel!
    
    var expense: RExpense! {
        didSet {
            amountLabel.text = "$\(expense.amount)"
            noteLabel.text = "\(expense.note)"
            noteLabel.sizeToFit()
            
            let user = RUser.getUserById(id: expense.userId)
            
            if let imageURL = user?.photoUrl {
                let url = URL(string: imageURL)!
                let resource = ImageResource(downloadURL: url, cacheKey: "\(imageURL)")
                self.profileImageView.kf.setImage(with: resource, placeholder: UIImage(named:"placeholder"), options: [.transition(.fade(0.2))])
            }
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
