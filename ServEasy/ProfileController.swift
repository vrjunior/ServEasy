//
//  ProfileController.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 27/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class ProfileController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editProfilePicture: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        
        
        //changing color of separators
        self.tableView.separatorColor = UIColor.primaryColor
        
        //removing separators from empty space
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    @IBAction func onTapEditButton(_ sender: Any) {
        if(self.tableView.isEditing) {
            self.tableView.setEditing(false, animated: true)
            self.editButton.setTitle("EDIT".localized, for: .normal)
            self.editProfilePicture.isHidden = true
        }
        else {
            self.tableView.setEditing(true, animated: true)
            self.editButton.setTitle("DONE".localized, for: .normal)
            self.editProfilePicture.isHidden = false
        }
    }
    @IBAction func onTapEditProfilePictureButton(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "TAKE_PHOTO".localized, style: .default, handler: takeAProfiePhoto))
        actionSheet.addAction(UIAlertAction(title: "CHOOSE_PHOTO".localized, style: .default, handler: chooseAProfilePhoto))
        actionSheet.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func takeAProfiePhoto(alert: UIAlertAction!) {
        self.imagePicker.sourceType = .camera
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    func chooseAProfilePhoto(alert: UIAlertAction!) {
        self.imagePicker.sourceType = .photoLibrary
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //updating image
            self.profileImage.image = pickedImage
            
            //update on server
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
