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

    var nearServices:[Servicer] = [Servicer]()
    var servicerRepository = ServicerRepository()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var currentLocation: CLLocation!
    var currentMapZoom: Float = 15 //initial zoom
    var newSearchLocation:CLGeocoder? = CLGeocoder()
    
    let servicerSegue = "servicerSegue"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var _myMapLocation: CLLocationCoordinate2D!
    var myMapLocation: CLLocationCoordinate2D {
        get {
            return _myMapLocation
        }
        set {
            self._myMapLocation = newValue
            self.mapView.clear()
            self.updateNearServices()
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change the tint color of tabbar
        self.tabBarController?.tabBar.tintColor = UIColor.primaryColor

        
        //fix searchbar
        self.fixSearchBar()
        
        self.mapView.delegate = self
        searchBar.delegate = self
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == self.servicerSegue) {
            
            //getting the controller
            let servicerController = segue.destination as! ServicerController
            
            //casting the sender to servicer
            let servicer = sender as! Servicer
            
            servicerController.currentServicer =  servicer
            servicerController.myMapLocation = self.myMapLocation
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
        let currentRadius = self.getMapVisibleRadiusInKM()
        
        self.nearServices = self.servicerRepository.getServicersByLocation(location: self.myMapLocation, radius: currentRadius)
    }
    
    func getMapVisibleRadiusInKM() -> Double {
        let center = CLLocation(latitude: self.myMapLocation.latitude, longitude: self.myMapLocation.longitude)
        //getting northEast point
        let farRightPosition = self.mapView.projection.visibleRegion().farRight
        
        let farRight = CLLocation(latitude: farRightPosition.latitude, longitude: farRightPosition.longitude)
        
        //return the distance in km
        return center.distance(from: farRight) / 1000
        
    }
    
}

extension SearchController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //getting the last location
        self.currentLocation = locations.first
        
        //getting the current coordinate
        let coordinate = self.currentLocation.coordinate
        
        self.mapView.camera = GMSCameraPosition(target: coordinate, zoom: self.currentMapZoom, bearing: 0, viewingAngle: 0)
        
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        self.mapView.selectedMarker = marker
        return true
    }
    
    //func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
    //    self.locationManager.stopUpdatingLocation()
    //    self.myMapLocation = position.target
    //}
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        self.locationManager.stopUpdatingLocation()
        self.myMapLocation = position.target
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: self.servicerSegue, sender: self.nearServices[indexPath.row])
    }
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
                    cell.thumbnail.backgroundColor = UIColor.clear
                    cell.thumbnail.image = image
                })
                
            }).resume()
        }
        
        cell.servicerName.text = currentServicer.name
        cell.servicerCategory.text = currentServicer.category?.name
        
        if let rating = currentServicer.rating {
            cell.ratingView.setRating(rating: rating)
        }
        
        if(currentServicer is EstablishmentServicer) {
            let estServicer = currentServicer as! EstablishmentServicer
            
            if let estLocation = estServicer.location {
                let distanceKm = estServicer.getKmDistance(fromPosition: self.myMapLocation)
                
                cell.servicerDistancy.text = " \(String(format: "%.1f", distanceKm)) km"
                
                //TODO I don't know if here is the best place to create the markers
                let marker = GMSMarker()
                marker.icon = estServicer.category?.getMarkerIcon()
                marker.title = estServicer.name
                marker.snippet = estServicer.category?.name
                marker.position = estLocation
                
                marker.map = self.mapView
                cell.separatorView.isHidden = false
                cell.servicerInfo.text = estServicer.isOpen() ? "OPEN".localized : "CLOSED".localized
            }
        } else {
            cell.servicerDistancy.text = "WORKS_ON_AREA".localized
            cell.separatorView.isHidden = true
            cell.servicerInfo.text = ""
            
        }
        
    
        
        return cell
    }
}
