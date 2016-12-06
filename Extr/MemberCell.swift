//
//  MemberCell.swift
//  Extr
//
//  Created by Zekun Wang on 11/28/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Kingfisher

class MemberCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameView: UIView!
    @IBOutlet var nameLabel: UILabel!
    
    var hasBorder: Bool = false
    var member: RMember! {
        didSet {
            let userId = member.userId
            let user = RUser.getUserById(id: userId)
            
            if let imageURL = user?.photoUrl {
                let url = URL(string: imageURL)!
                let resource = ImageResource(downloadURL: url, cacheKey: "\(imageURL)")
                self.profileImageView.kf.setImage(with: resource, placeholder: UIImage(named:"placeholder"), options: [.transition(.fade(0.2))])
            }
            self.nameLabel.text = user?.fullname
            
            if hasBorder {
                self.profileImageView.layer.borderWidth = 1
                self.nameView.layer.borderWidth = 1
            } else {
                self.profileImageView.layer.borderWidth = 0
                self.nameView.layer.borderWidth = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.profileImageView.layer.cornerRadius = 20
        self.profileImageView.clipsToBounds = true
        
        self.nameView.layer.cornerRadius = 20
        self.nameView.clipsToBounds = true
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.nameView.layer.borderColor = UIColor.black.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
