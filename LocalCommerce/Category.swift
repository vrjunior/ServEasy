//
//  Category.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 28/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation
import UIKit

public class Category {
    public var id:Int
    public var name: String
    
    init(id:Int, name:String) {
        self.id = id
        self.name = name
    }
    
    func getMarkerIcon() -> UIImage {
        let path = "categoryMarker\(self.id)"
        if let icon = UIImage(named: path) {
            return icon
        }
        return UIImage()
    }
}
