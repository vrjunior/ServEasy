//
//  Commerce.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 28/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation
import CoreLocation

class Commerce {
    public var name:String?
    public var cnpj:String?
    public var openingTime:(hour: Int, minute: Int, second: Int)?
    public var closingTime:(hour: Int, minute: Int, second: Int)?
    public var location:CLLocationCoordinate2D?
    public var rating: Float?
    
    public func isOpen() -> Bool {
        return true
    }
    
    public func setLocation(latitude: Double, longitude: Double) {
        
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
