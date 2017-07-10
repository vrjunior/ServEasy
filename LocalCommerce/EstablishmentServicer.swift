//
//  EstablishmentServicer.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 03/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation
import CoreLocation
import GoogleMaps

class EstablishmentServicer: Servicer {
    
    public var openingTime:(hour: Int, minute: Int)?
    public var closingTime:(hour: Int, minute: Int)?
    public var location:CLLocationCoordinate2D?
    public var addressStreet:String?
    public var addressNumber: Int?
    public var addressCity: String?
    public var addressUF: String?
    public var facadeImagesUrls: [String]?
    
    public func isOpen() -> Bool {
        return true
    }
    
    public func setLocation(latitude: Double, longitude: Double) {
        
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    
    public func getKmDistance(fromPosition coordinate:CLLocationCoordinate2D) -> Double{
        let mapLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let servicerLocation = CLLocation(latitude: self.location!.latitude, longitude: self.location!.longitude)
        
        let distanceKm = mapLocation.distance(from: servicerLocation) / 1000
        
        return distanceKm
    }
    
}
