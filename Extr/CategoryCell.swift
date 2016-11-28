//
//  CategoryCell.swift
//  Extr
//
//  Created by Zekun Wang on 11/24/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var iconBackgroundImageView: UIImageView!
    @IBOutlet var iconLabel: UILabel!
    
    var category: RCategory! {
        didSet {
            iconBackgroundImageView.backgroundColor = UIColor.HexToColor(hexString: category.color)
            iconImageView.image = UIImage(named: category.icon)?.withRenderingMode(.alwaysTemplate)
            iconLabel.text = category.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        iconImageView.tintColor = UIColor.white

        iconBackgroundImageView.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UIColor{
    static func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}
