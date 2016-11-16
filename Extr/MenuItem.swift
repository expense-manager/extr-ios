//
//  MenuItem.swift
//  Extr
//
//  Created by Zekun Wang on 11/15/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class MenuItem: NSObject {
    
    var icon: UIImage!
    var label: String
    
    init(icon: UIImage!, label: String) {
        self.icon = icon
        self.label = label
    }
}
