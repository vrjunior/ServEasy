//
//  ViewController.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 27/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class SearchController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var myMarkerPoint: GMSMarker = GMSMarker()
    var currentMapZoom: Float = 15 //initial zoom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //setting market info
        self.myMarkerPoint.title = "My location"
        self.myMarkerPoint.snippet = "Current location"
        
        //adding current position marker to map
        self.myMarkerPoint.map = self.mapView
        
        self.determineMyCurrentLocation()
    }
    
    func determineMyCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //saving current zoom
        self.currentMapZoom = self.mapView.camera.zoom
        
        //getting the last location
        self.currentLocation = locations.first
        
        //getting the current coordinate
        let coordinate = self.currentLocation.coordinate
        
        self.mapView.camera = GMSCameraPosition(target: coordinate, zoom: self.currentMapZoom, bearing: 0, viewingAngle: 0)
        
        // Creates a marker in the center of the map.
        self.myMarkerPoint.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
    }

}

