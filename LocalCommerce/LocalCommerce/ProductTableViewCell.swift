//
//  ProductTableViewCell.swift
//  LocalCommerce
//
//  Created by João Agostinho Hergert on 28/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {


    @IBOutlet weak var productName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
