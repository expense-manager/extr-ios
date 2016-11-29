//
//  CategoryFilterCell.swift
//  Extr
//
//  Created by Zekun Wang on 11/29/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CategoryFilterCell: UICollectionViewCell {

    @IBOutlet var categoryView: UIView!
    @IBOutlet var selectImageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    var isSelectedCategory: Bool = false
    
    var category: RCategory! {
        didSet {
            if category == nil {
                categoryView.layer.borderColor = UIColor.lightGray.cgColor
                backgroundImageView.backgroundColor = UIColor.lightGray
                iconImageView.isHidden = true
                nameLabel.text = "No Category"
                if isSelectedCategory {
                    selectImageView.isHidden = false
                    selectImageView.layer.borderColor = UIColor.lightGray.cgColor
                } else {
                    selectImageView.isHidden = true
                }
            } else {
                let color: UIColor = UIColor.HexToColor(hexString: category.color)
                categoryView.layer.borderColor = color.cgColor
                backgroundImageView.backgroundColor = color
                iconImageView.image = UIImage(named: category.icon)?.withRenderingMode(.alwaysTemplate)
                iconImageView.isHidden = false
                nameLabel.text = category.name
                if isSelectedCategory {
                    selectImageView.isHidden = false
                    selectImageView.layer.borderColor = color.cgColor
                } else {
                    selectImageView.isHidden = true
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryView.layer.borderWidth = 1
        iconImageView.tintColor = UIColor.white
        backgroundImageView.layer.cornerRadius = 20
        selectImageView.layer.cornerRadius = 24
        selectImageView.layer.borderWidth = 2
    }

}
