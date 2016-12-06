//
//  GroupDetailViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/16/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import Kingfisher

class GroupDetailViewController: UIViewController {

    @IBOutlet var groupInfoView: UIView!
    @IBOutlet var groupActionsView: UIView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var groupnameLabel: UILabel!
    @IBOutlet var taglineLabel: UILabel!
    @IBOutlet var createrProfileImageView: UIImageView!
    @IBOutlet var groupCreationInfoLabel: UILabel!
   
    @IBOutlet var memberView: UIView!
    @IBOutlet var memberCountLabel: UILabel!
    
    let memberListViewControllerString = "MemberListViewController"
    
    var hamburgerViewController: HamburgerViewController!
    var groupId: String!
    var userId: String!
    var group: RGroup! {
        didSet {
            if let userId = group?.userId {
                let user = RUser.getUserById(id: userId)
                if let imageURL = user?.photoUrl {
                    let url = URL(string: imageURL)!
                    let resource = ImageResource(downloadURL: url, cacheKey: "\(imageURL)")
                    self.createrProfileImageView.kf.setImage(with: resource, placeholder: UIImage(named:"placeholder"), options: [.transition(.fade(0.2))])
                }
                
//                createdAtTextView.setText("" + createdBy.getFullname() + " created this group on " + Helpers.getMonthDayYear(group.getCreatedAt()));
                groupCreationInfoLabel.text = (user?.fullname)! + " created this group on " + Helpers.getMonthDayYear(date: group.createdAt)
            }
            nameLabel.text = group.name
            groupnameLabel.text = "@\(group.groupname)"
            taglineLabel.text = group.about
            
            memberCountLabel.text = String(RMember.getMembersByGroupId(groupId: group.id).count)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppConstants.cyan_deep
        createrProfileImageView.layer.cornerRadius = 25
        createrProfileImageView.clipsToBounds = true
        
        groupInfoView.layer.cornerRadius = 10
        groupInfoView.clipsToBounds = true
        
        groupActionsView.layer.cornerRadius = 10
        groupActionsView.clipsToBounds = true
        
        let memberViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toMemberList))
        memberView.addGestureRecognizer(memberViewTapRecognizer)
        
        self.navigationController?.navigationBar.barTintColor = AppConstants.cyan
        
        loadData()
    }
    
    func toMemberList(sender : UITapGestureRecognizer) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let memberListViewController = storyBoard.instantiateViewController(withIdentifier: memberListViewControllerString) as! MemberListViewController
        present(memberListViewController, animated: true, completion: nil)
    }
    
    func loadData() {
        let userDefault = UserDefaults.standard
        userId = userDefault.string(forKey: RMember.JsonKey.userId)
        groupId = userDefault.string(forKey: RMember.JsonKey.groupId)
        if groupId == nil {
            print("no group saved")
            return
        }
        
        group = RGroup.getGroupById(id: groupId)
        SyncGroup.getGroupById(groupId: groupId, success: { (group: RGroup) -> () in
            self.group = group
        }) { (error: Error) -> () in
            print(error)
        }
    }
    
    func setupNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 64))
        let navigationItem = UINavigationItem(title: "Group")
        navigationBar.backgroundColor = UIColor.white
        navigationBar.isTranslucent = false
        navigationBar.items = [navigationItem]
        self.view.addSubview(navigationBar)
        
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
