//
//  MemberListSectionHeader.swift
//  Extr
//
//  Created by Zekun Wang on 12/4/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class MemberListSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet var headerLabel: UILabel!
    
    var headerInfo: HeaderInfo! {
        didSet {
            headerLabel.text = headerInfo.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
