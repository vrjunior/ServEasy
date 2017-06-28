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

class SearchController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var myMarkerPoint: GMSMarker = GMSMarker()
    var currentMapZoom: Float = 15 //initial zoom
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        
        //setting market info
        self.myMarkerPoint.title = "My location"
        self.myMarkerPoint.snippet = "Current location"
        
        //adding current position marker to map
        self.myMarkerPoint.map = self.mapView
        
        //defining style to hide poi on google maps
        let myStyle = "[" +
            "  {" +
            "    \"featureType\": \"poi\"," +
            "    \"elementType\": \"all\"," +
            "    \"stylers\": [" +
            "      {" +
            "        \"visibility\": \"off\"" +
            "      }" +
            "    ]" +
            "  }," +
            "  {" +
            "    \"featureType\": \"transit\"," +
            "    \"elementType\": \"labels.icon\"," +
            "    \"stylers\": [" +
            "      {" +
            "        \"visibility\": \"off\"" +
            "      }" +
            "    ]" +
            "  }" +
        "]"
        
        do {
            try self.mapView.mapStyle = GMSMapStyle(jsonString: myStyle)
        } catch {
            NSLog("Fail to set style on google maps")
        }
        
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

    @IBAction func locationSync(_ sender: UIButton) {
        self.locationManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension SearchController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //getting the last location
        self.currentLocation = locations.first
        
        //getting the current coordinate
        let coordinate = self.currentLocation.coordinate
        
        self.mapView.camera = GMSCameraPosition(target: coordinate, zoom: self.currentMapZoom, bearing: 0, viewingAngle: 0)
        
        // Creates a marker in the center of the map.
        self.myMarkerPoint.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        //saving current zoom to next update
        self.currentMapZoom = self.mapView.camera.zoom
        
    }
}

extension SearchController: GMSMapViewDelegate {
    
    /*func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {

        self.locationManager.stopUpdatingLocation()
        self.myMarkerPoint.position = coordinate
        
        //center the camera to marker stay on center
        self.mapView.animate(toLocation: coordinate)
    }*/
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        self.locationManager.stopUpdatingLocation()
        self.myMarkerPoint.position = position.target
    }
}
