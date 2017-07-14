//
//  NewBudgetViewController.swift
//  LocalCommerce
//
//  Created by Rafael Sol Santos Martins on 11/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation
import UIKit

class NewBudgetViewController : UIViewController{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var localTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewBudgetViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewBudgetViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        scrollView.delegate = self
        localTextField.delegate = self
        descriptionTextField.delegate = self
        
        self.navigationController?.navigationBar.backItem?.title = "Beterraba"
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
    //    self.navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = UIColor.white
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
}



extension NewBudgetViewController: UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate{
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
    //    scrollView.setContentOffset(CGPoint.init(x: 0, y: -50), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       // scrollView.setContentOffset(CGPoint.init(x: 0, y: -50), animated: true)
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
}
