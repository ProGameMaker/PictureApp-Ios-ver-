//
//  ViewController.swift
//  test
//
//  Created by Nguyễn Trí on 2/20/19.
//  Copyright © 2019 Nguyễn Trí. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    
    @IBOutlet var leadingMenu: NSLayoutConstraint!
    @IBOutlet var subViewHeight: NSLayoutConstraint!
    @IBOutlet var subview: UIView!
    @IBOutlet var subMenu: UIView!
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var hiddenMenuButton: UIButton!
    
    var newImage: UIImage?
    var currentSender: UIButton?
    
    var imagePicker = UIImagePickerController()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imagePicker.delegate = self as UIImagePickerControllerDelegate as? UIImagePickerControllerDelegate & UINavigationControllerDelegate;
        newImage = nil;
        hiddenMenuButton.addTarget(self, action: #selector(openMenu), for:.touchUpInside);
        hiddenMenuButton.isHidden = true;
        leadingMenu.constant = -240;
    }
    
    @IBAction func add(_ sender: Any) {
        
        print(subview.heightAnchor);
        
        // create card
        let newView = UIView()
        
        newView.backgroundColor = UIColor.lightGray;
        newView.frame.size = CGSize(width: 328, height: 500);
        newView.center = CGPoint(x: self.view.frame.width/2, y: 0);
        
        if (subview.subviews.isEmpty) {
            print("first");
            newView.frame.origin.y = 30;
        }
        else {
            newView.frame.origin.y = (subview.subviews.last?.frame.origin.y)! + (subview.subviews.last?.frame.height)! + 30;
        }
        
        // create image
        let imageName = "images.png";
        let image = UIImage(named: imageName);
        let imageView = UIImageView(image: image);
        imageView.frame = CGRect(x: 0, y: 0, width: newView.frame.width, height: 200);
        newView.addSubview(imageView);
        
        // create uitextview
        let content = UITextView();
        content.isEditable = true;
        content.text = "Enter some thing here";
        content.frame = CGRect(x: 0, y: imageView.frame.height, width: newView.frame.width, height: 250);
        content.font = UIFont(name: content.font!.fontName, size: 20)
        
        newView.addSubview(content);
        
        // create button
        let delButton = UIButton()
        delButton.frame = CGRect(x: newView.frame.width * 0.85, y: content.frame.origin.y + content.frame.height + 10, width: 60, height: 30)
        delButton.setImage(UIImage(named: "icons8-trash-50.png")!, for: .normal)
        delButton.imageView?.contentMode = .scaleAspectFit
        delButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        
        newView.addSubview(delButton);

        delButton.addTarget(self,  action:#selector(delete), for: .touchUpInside);
        
        let editButton = UIButton()
        editButton.frame = CGRect(x: newView.frame.width * 0.7, y: content.frame.origin.y + content.frame.height + 10, width: 60, height: 30)
        editButton.setImage(UIImage(named: "icons8-green-check-mark-filled-50")!, for: .normal)
        editButton.imageView?.contentMode = .scaleAspectFit
        editButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        newView.addSubview(editButton);
        
        editButton.addTarget(self,  action:#selector(edit), for: .touchUpInside);
        
        let changeButton = UIButton()
        changeButton.frame = CGRect(x: newView.frame.width * 0.05, y: content.frame.origin.y + content.frame.height + 10, width: 60, height: 30);
        changeButton.setImage(UIImage(named: "icons8-pictures-folder-filled-50.png")!, for: .normal)
        changeButton.imageView?.contentMode = .scaleAspectFit
        changeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        newView.addSubview(changeButton);
        
        changeButton.addTarget(self, action:#selector(change), for: .touchUpInside);
        
        // alert
        let alert = UIAlertController(title: "Note", message: "Add page complete", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        subview.addSubview(newView);
        print(newView);
        
        IsOver();
    }
    
    func IsOver() -> Void {
        
        subViewHeight.constant = 30;
        for item in subview.subviews {
            subViewHeight.constant += item.frame.height + 35;
        }
    }
    
    @objc func delete(sender: UIButton!) {
        
        let alert = UIAlertController(title: "Delete", message: "Do you want to delete this page", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: { action in
             sender.superview?.removeFromSuperview();
            self.ReOrder();
        }
        ))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @objc func change(sender: UIButton) {
        
        ChangePic();
        currentSender = sender;
    }
    
    func ChangePic() {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        /*switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }*/
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func edit(sender: UIButton!) {
        
        print("edit");
        if ((sender.superview?.subviews[1] as! UITextView).isEditable) {
            (sender.superview?.subviews[1] as! UITextView).isEditable = false;
            sender.setImage(UIImage(named: "icons8-edit-filled-50.png")!, for: .normal)
        }
        else {
            (sender.superview?.subviews[1] as! UITextView).isEditable = true;
            sender.setImage(UIImage(named: "icons8-green-check-mark-filled-50")!, for: .normal)
        }
        
        (sender.superview?.subviews[4] as! UIButton).isHidden = !(sender.superview?.subviews[4] as! UIButton).isHidden;
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("didFinish")
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        // do something interesting here!
        (currentSender?.superview?.subviews[0] as! UIImageView).image = newImage;
        dismiss(animated: true)
    }
    
    func ReOrder() -> Void {
        
        IsOver();
        for i in 0..<subview.subviews.count {
            
            if (i == 0) {
                subview.subviews[0].frame.origin.y = 30;
            }
            else {
                subview.subviews[i].frame.origin.y =  subview.subviews[i - 1].frame.origin.y + subview.subviews[i - 1].frame.height + 30;
            }
        }
        
    }
    
    
    @objc func openMenu() {
        
        if (leadingMenu.constant == 0) {
            leadingMenu.constant = -240;
        }
        else {
            leadingMenu.constant = 0;
        }
        
        hiddenMenuButton.isHidden = !hiddenMenuButton.isHidden;
        
        UIView.animate(withDuration: 0.3, animations: {self.view.layoutIfNeeded()})
        
    }
    
    @IBAction func OpenMenu(_ sender: Any) {
        openMenu();
    }
    
}

