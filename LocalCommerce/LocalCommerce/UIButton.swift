//
//  UIButton.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
}
