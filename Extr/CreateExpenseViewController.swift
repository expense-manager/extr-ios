//
//  CreateExpenseViewController.swift
//  Extr
//
//  Created by Zhaolong Zhong on 11/27/16.
//  Copyright © 2016 Expense Manager. All rights reserved.
//

import UIKit
import MobileCoreServices

class CreateExpenseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var noteTextField: UITextField!
    @IBOutlet var expenseDataTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    
    var newMedia: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        
        let navItem = UINavigationItem(title: "");
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(CreateExpenseViewController.cancel))
        let doneItem = UIBarButtonItem(title: "Post", style: .done, target: nil, action: #selector(CreateExpenseViewController.post))
        
        navItem.leftBarButtonItem = cancelItem
        navItem.rightBarButtonItem = doneItem;
        navBar.setItems([navItem], animated: false);
        
        let titleImageView = UIImageView(image: UIImage(named: "Camera"))
        titleImageView.isUserInteractionEnabled = true
        let titleRecognizer = UITapGestureRecognizer(target: self, action: #selector(CreateExpenseViewController.titleImageViewTapped))
        titleImageView.addGestureRecognizer(titleRecognizer)
        navItem.titleView = titleImageView
        
        self.view.addSubview(navBar)
        
        self.hideKeyboardWhenTappedAround()
    }
    
    func post() {
        
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func titleImageViewTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let takePhotoActionSheet = UIAlertAction(title: "Take a photo", style: .default, handler: {(action) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                
                self.present(imagePicker, animated: true,
                             completion: nil)
                self.newMedia = true
            }
            
        })
        
        let choosePhotoActionSheet = UIAlertAction(title: "Choose a photo", style: .default, handler: {(action) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(
                UIImagePickerControllerSourceType.savedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true,
                             completion: nil)
                self.newMedia = false
            }
        })

        alertController.addAction(takePhotoActionSheet)
        alertController.addAction(choosePhotoActionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage]
                as! UIImage
            
            imageView.image = image
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                                               #selector(CreateExpenseViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
            } else if mediaType.isEqual(to: kUTTypeMovie as String) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafeRawPointer) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                                          message: "Failed to save image",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.present(alert, animated: true,
                         completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Must set View controller-based status bar appearance to NO in Info.plist
        // to use isStatusBarHidden
        UIApplication.shared.isStatusBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
        self.setNeedsStatusBarAppearanceUpdate()
        super.viewWillDisappear(animated)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
