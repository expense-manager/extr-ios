//
//  CategoryReportRankCell.swift
//  Extr
//
//  Created by Zekun Wang on 12/6/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CategoryReportRankCell: UICollectionViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var backgroundImageView: UIImageView!
    
    var categoryId: String! {
        didSet {
            if let category = RCategory.getCategoryById(id: categoryId) {
                backgroundImageView.backgroundColor = UIColor.HexToColor(hexString: category.color)
                iconImageView.isHidden = false
                iconImageView.image = UIImage(named: category.icon)?.withRenderingMode(.alwaysTemplate)
            } else {
                backgroundImageView.backgroundColor = UIColor.lightGray
                iconImageView.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.layer.cornerRadius = 17
        backgroundImageView.clipsToBounds = true
        iconImageView.tintColor = UIColor.white
    }

}
