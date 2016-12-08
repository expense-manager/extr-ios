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
    
    @IBOutlet var categoryLabel: UILabel!
    
    let categoryViewControllerString = "CategoryViewController"
    
    var hamburgerViewController: HamburgerViewController!
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
                weeklyBudgetAmountLabel.text = "$\(Helpers.getFormattedAmount(amount: group.weeklyBudget))"
                monthlyBudgetAmountLabel.text = "$\(Helpers.getFormattedAmount(amount: group.monthlyBudget))"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImageView.layer.cornerRadius = 40
        profileImageView.clipsToBounds = true
        
        let categoryTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(onCategoryTapped))
        categoryLabel.isUserInteractionEnabled = true
        categoryLabel.addGestureRecognizer(categoryTapRecognizer)
        
        navigationController?.navigationBar.barTintColor = AppConstants.cyan
        navigationController?.navigationBar.tintColor = UIColor.white
        
        loadData()
    }
    
    func loadData() {
        let userDefault = UserDefaults.standard
        userId = userDefault.string(forKey: RMember.JsonKey.userId)
        groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        if userId == nil {
            print("no user saved")
            group = nil
            return
        }
        
        user = RUser.getUserById(id: userId)
        group = RGroup.getGroupById(id: groupId)
    }
    
    func onCategoryTapped(gestureRecognizer: UIGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let categoryViewController = storyBoard.instantiateViewController(withIdentifier: categoryViewControllerString)
        navigationController?.pushViewController(categoryViewController, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func hamburgerIconTapped(_ sender: UIBarButtonItem) {
        hamburgerViewController?.isMenu = true
        hamburgerViewController?.attachGrayoutView()
        hamburgerViewController?.openMenu()
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
