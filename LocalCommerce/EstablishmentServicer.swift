//
//  EstablishmentServicer.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 03/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class EstablishmentServicer: Servicer {
    
    public var openingTime:(hour: Int, minute: Int)?
    public var closingTime:(hour: Int, minute: Int)?
    public var location:CLLocationCoordinate2D?
    public var addressStreet:String?
    public var addressNumber: Int?
    public var addressCity: String?
    public var addressUF: String?
    public var facadeImages: UIImage?
    
    public func isOpen() -> Bool {
        return true
    }
    
    public func setLocation(latitude: Double, longitude: Double) {
        
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
