//
//  ServicerController.swift
//  LocalCommerce
//
//  Created by Rafael Sol Santos Martins on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class ServicerController : UIViewController {
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
