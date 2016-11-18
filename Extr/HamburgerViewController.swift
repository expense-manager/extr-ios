//
//  HamburgerViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/14/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    
    let menuViewControllerString = "MenuViewController"
    let menuGroupThreshold: CGFloat = 40
    let viewAnimationDuration: Double = 0.3
    
    @IBOutlet var groupView: UIView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var menuView: UIView!
    
    var originalCenterPoint: CGPoint!
    var isMenu: Bool!
    var openMenuCenterPointX: CGFloat!
    var closeMenuCenterPointX: CGFloat!
    var openGroupCenterPointX: CGFloat!
    var closeGroupCenterPointX: CGFloat!
    var grayOutView: UIView = UIView()
    
    var menuViewController: MenuViewController! {
        didSet {
            menuViewController.view.frame.size.width = menuView.frame.width
            menuView.addSubview(menuViewController.view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Menu group center points
        closeMenuCenterPointX = menuView.center.x
        openMenuCenterPointX = -closeMenuCenterPointX
        closeGroupCenterPointX = containerView.center.x
        openGroupCenterPointX = closeGroupCenterPointX - groupView.bounds.width
        
        // Gray out view
        grayOutView.frame = containerView.frame
        grayOutView.alpha = 0
        grayOutView.backgroundColor = UIColor.black
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(grayOutViewOnTap))
        grayOutView.addGestureRecognizer(tapGesture)
        
        // Menu view
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.menuViewController = storyboard.instantiateViewController(withIdentifier: self.menuViewControllerString) as! MenuViewController
        self.menuViewController.hamburgerViewController = self
    }
    
    func grayOutViewOnTap(sender : UITapGestureRecognizer) {
        isMenu == true ? closeMenu() : closeGroup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHamburgerPanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: self.view)
        let velocity = sender.velocity(in: self.view)
        let transition = sender.translation(in: self.view)
        
        if sender.state == .began {
            if isMenu == nil {
                if velocity.x > 0 {
                    isMenu = true
                } else {
                    isMenu = false
                }
                containerView.addSubview(grayOutView)
            }
            originalCenterPoint = isMenu == true ? menuView.center : containerView.center
        } else if sender.state == .changed {
            let newCenterX = originalCenterPoint.x + transition.x
            
            if isMenu == true {
                if (newCenterX - openMenuCenterPointX) > 0 || (newCenterX - closeMenuCenterPointX) < 0 {
                    return
                }
                menuView.center.x = newCenterX
                grayOutView.alpha = (newCenterX - closeMenuCenterPointX) / menuView.bounds.width * 0.6
            } else {
                if (newCenterX - openGroupCenterPointX) < 0 || (newCenterX - closeGroupCenterPointX) > 0 {
                    return
                }
                containerView.center.x = newCenterX
                grayOutView.alpha = (closeGroupCenterPointX - newCenterX) / groupView.bounds.width * 0.6
            }
        } else if sender.state == .ended {
            let newCenterX = originalCenterPoint.x + transition.x
            
            if isMenu == true {
                if velocity.x > 0 {
                    newCenterX - closeMenuCenterPointX >= menuGroupThreshold ? openMenu() : closeMenu()
                } else {
                    openMenuCenterPointX - newCenterX >= menuGroupThreshold ? closeMenu() : openMenu()
                }
            } else {
                if velocity.x > 0 {
                    newCenterX - openGroupCenterPointX >= menuGroupThreshold ? closeGroup() : openGroup()
                } else {
                    closeGroupCenterPointX - newCenterX >= menuGroupThreshold ? openGroup() : closeGroup()
                }
            }
        }
    }
    
    func openMenu() {
        UIView.animate(withDuration: viewAnimationDuration) {
            self.menuView.center.x = self.openMenuCenterPointX
            self.grayOutView.alpha = 0.6
        }
    }
    
    func closeMenu() {
        UIView.animate(withDuration: viewAnimationDuration, animations: {
            self.menuView.center.x = self.closeMenuCenterPointX
            self.grayOutView.alpha = 0
        }, completion: {finished in
            self.grayOutView.removeFromSuperview()
        })
        isMenu = nil
    }
    
    func openGroup() {
        UIView.animate(withDuration: viewAnimationDuration) {
            self.containerView.center.x = self.openGroupCenterPointX
            self.grayOutView.alpha = 0.6
        }
    }
    
    func closeGroup() {
        UIView.animate(withDuration: viewAnimationDuration, animations: {
            self.containerView.center.x = self.closeGroupCenterPointX
            self.grayOutView.alpha = 0
        }, completion: {finished in
            self.grayOutView.removeFromSuperview()
        })
        isMenu = nil
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
