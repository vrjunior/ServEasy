//
//  SearchFilterTableViewCell.swift
//  LocalCommerce
//
//  Created by João Agostinho Hergert on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class SearchFilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterCellHeight: NSLayoutConstraint!
    
    var isExpanded:Bool = false
    {
        didSet
        {
            if !isExpanded {
                self.filterCellHeight.constant = 0.0
                
            } else {
                self.filterCellHeight.constant = 128.0
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
