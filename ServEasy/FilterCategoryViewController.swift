//
//  FilterCategoryViewController.swift
//  LocalCommerce
//
//  Created by João Agostinho Hergert on 14/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class FilterCategoryViewController: UIViewController {

    @IBOutlet weak var service: UILabel!
    
    var serviceID: Int?
    
    override func viewDidLoad() {
    
    
        service.text = String(serviceID!)
    
    }

    


}
