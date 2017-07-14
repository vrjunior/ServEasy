//
//  ProductTableViewCell.swift
//  LocalCommerce
//
//  Created by João Agostinho Hergert on 28/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class ServicerTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!

    @IBOutlet weak var servicerName: UILabel!
    @IBOutlet weak var servicerCategory: UILabel!
    @IBOutlet weak var servicerDistancy: UILabel!
    @IBOutlet weak var servicerInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
