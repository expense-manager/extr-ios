//
//  HamburgerViewController.swift
//  Extr
//
//  Created by Zekun Wang on 11/14/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        closeMenuCenterPointX = menuView.center.x
        openMenuCenterPointX = -closeMenuCenterPointX
        closeGroupCenterPointX = containerView.center.x
        openGroupCenterPointX = closeGroupCenterPointX - groupView.bounds.width
        
        grayOutView.frame = containerView.frame
        grayOutView.alpha = 0
        grayOutView.backgroundColor = UIColor.black
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
            if isMenu == true {
                velocity.x > 0 ? openMenu() : closeMenu()
            } else {
                velocity.x > 0 ? closeGroup() : openGroup()
            }
        }
    }
    
    func openMenu() {
        UIView.animate(withDuration: 0.4) {
            self.menuView.center.x = self.openMenuCenterPointX
            self.grayOutView.alpha = 0.6
        }
    }
    
    func closeMenu() {
        UIView.animate(withDuration: 0.4, animations: {
            self.menuView.center.x = self.closeMenuCenterPointX
            self.grayOutView.alpha = 0
        }, completion: {finished in
            self.grayOutView.removeFromSuperview()
        })
        isMenu = nil
    }
    
    func openGroup() {
        UIView.animate(withDuration: 0.4) {
            self.containerView.center.x = self.openGroupCenterPointX
            self.grayOutView.alpha = 0.6
        }
    }
    
    func closeGroup() {
        UIView.animate(withDuration: 0.4, animations: {
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
