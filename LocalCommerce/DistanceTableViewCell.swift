//
//  DistanceTableViewCell.swift
//  LocalCommerce
//
//  Created by João Agostinho Hergert on 12/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class DistanceTableViewCell: UITableViewCell {

    @IBOutlet weak var distance: UISlider!
    
    
    @IBOutlet weak var distanceValue: UILabel!
    
    
    @IBAction func distanceChanged(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        
        distanceValue.text = "\(currentValue) km"
        
    }
    
}
