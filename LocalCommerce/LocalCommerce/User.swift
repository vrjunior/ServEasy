//
//  User.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 28/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class User {
    public var id: Int?
    public var firstName: String?
    public var lastName: String?
    public var token: String?
    public var profilePicture: UIImage?
    public var email: String?
    public var lastLocation: CLLocationCoordinate2D?
    
    
    public func setLastLocation(latitude: Double, longitude: Double) {
        self.lastLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
}
