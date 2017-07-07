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

    // For test
    var array = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var nearServices:[Servicer] = [Servicer]()
    var servicerRepository = ServicerRepository()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation!
    var myMarkerPoint: GMSMarker = GMSMarker()
    var currentMapZoom: Float = 15 //initial zoom
    var newSearchLocation:CLGeocoder? = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change the tint color of tabbar
        self.tabBarController?.tabBar.tintColor = UIColor.primaryColor

        
        //fix searchbar
        self.fixSearchBar()
        
        self.mapView.delegate = self
        searchBar.delegate = self
        
        
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
        
        self.updateNearServices()
        
    }
    
    func fixSearchBar() {
        //adding searchbar on navigation bar
        self.navigationItem.titleView = searchBar
        
        //changing placeholder and label color
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.primaryColor
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.primaryColor
        
        
        //changing icon's color
        if let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView {
            
            //Magnifying glass
            glassIconView.image = glassIconView.image?.withRenderingMode(.alwaysTemplate)
            glassIconView.tintColor = UIColor.primaryColor
        
        }
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
    
    func updateNearServices() {
        //updating near services
        self.nearServices = self.servicerRepository.getServicersByLocation(location: self.myMarkerPoint.position, radius: 20)
        
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

extension SearchController: UISearchBarDelegate {
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //getting the geocode from searchtext
        self.newSearchLocation?.geocodeAddressString(searchBar.text!, completionHandler: { (placemarks, error) in
            if error == nil {
                for placemark in placemarks! {
                    print(placemark.name!)
                    
                    //updating position
                    if let location = placemark.location {
                        self.locationManager.stopUpdatingLocation()
                        
                        self.mapView.animate(toLocation: location.coordinate)
                    }
                    
                    
                }
            }
        })
        
        searchBar.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchBar.endEditing(true)
     //   self.view.resignFirstResponder()
    }
    
}

extension SearchController: UISearchDisplayDelegate{
    
    
}




extension SearchController: UICollectionViewDelegate {


}


extension SearchController: UICollectionViewDataSource {
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return self.nearServices.count
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Servicer", for: indexPath as IndexPath) as! ServicerCollectionViewCell
        
        let currentServicer = nearServices[indexPath.row]
        
        if let url = URL(string: currentServicer.thumbnailUrl!) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                
                if error != nil {
                    print(String(describing:error))
                    return
                }
                
                // a imagem recebida presica ser preenchida na main queue
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)
                    cell.thumbnail.image = image
                })
                
            }).resume()
        }
        
        cell.servicerName.text = currentServicer.name
        cell.servicerCategory.text = currentServicer.categoryName
        if(currentServicer is EstablishmentServicer) {
            let estServicer = currentServicer as! EstablishmentServicer
            
            if let estLocation = estServicer.location {
                cell.servicerDistancy.text = " \(GMSGeometryDistance(self.myMarkerPoint.position, estLocation) / 1000) km"
            }
            
            cell.servicerInfo.text = estServicer.isOpen() ? "Open" : "Close"
        }
        
    
        
        return cell
    }
}
