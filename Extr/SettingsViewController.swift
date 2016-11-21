//
//  SettingsViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/19/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Kingfisher

class SettingsViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    
    @IBOutlet var weeklyBudgetAmountLabel: UILabel!
    @IBOutlet var monthlyBudgetAmountLabel: UILabel!
    
    
    var groupId: String!
    var userId: String!
    var user: RUser! {
        didSet {
            if let imageURL = user?.photoUrl {
                let url = URL(string: imageURL)!
                let resource = ImageResource(downloadURL: url, cacheKey: "\(imageURL)")
                self.profileImageView.kf.setImage(with: resource, placeholder: UIImage(named:"placeholder"), options: [.transition(.fade(0.2))])
            }
        }
    }
    
    var group: RGroup! {
        didSet {
            if group != nil {
                weeklyBudgetAmountLabel.text = "$\(group.weeklyBudget)"
                monthlyBudgetAmountLabel.text = "$\(group.monthlyBudget)"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        loadData()

        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        let userDefault = UserDefaults.standard
        userId = userDefault.string(forKey: RMember.JsonKey.userId)
        groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        if userId == nil {
            print("no user saved")
            return
        }
        
        user = RUser.getUserById(id: userId)
        group = RGroup.getGroupById(id: groupId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
