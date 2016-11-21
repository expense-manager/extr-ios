//
//  GroupCell.swift
//  Extr
//
//  Created by Zekun Wang on 11/16/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet var iconLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var checkImageView: UIImageView!
    
    var member: RMember! {
        didSet {
            let group = RGroup.getGroupById(id: member.groupId)
            let name = group?.name
            if name == nil {
                return
            }
            nameLabel.text = name
            iconLabel.text = String(name![name!.startIndex]).capitalized
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            checkImageView.isHidden = !isChecked
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconLabel.layer.cornerRadius = 25
        iconLabel.clipsToBounds = true
        
        checkImageView.image = checkImageView.image?.withRenderingMode(.alwaysTemplate)
        // TODO: update color
        checkImageView.tintColor = UIColor.blue
        checkImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
