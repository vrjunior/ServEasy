//
//  WishlistController.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 27/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit
import CoreLocation

class FavoritesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()
    
    var favoriteServicers = [Servicer]()
    var filteredServicers = [Servicer]()
    var isFiltering: Bool = false
    
    var favoriteAccessLayer = FavoriteAccessLayer()
    
    override func viewDidLoad() {
        //removing empty cells
        self.tableView.tableFooterView = UIView()
        //adding color to separator
        self.tableView.separatorColor = UIColor.primaryColor
        
        self.fixSearchBar()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.favoriteServicers = self.favoriteAccessLayer.getFavoritesServicers()
        self.tableView.reloadData()
    }
    
    func fixSearchBar() {
        
        self.searchBar.delegate = self
        
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
    
}

extension FavoritesController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        if let location = locations.first {
            self.currentLocation = location
            self.tableView.reloadData()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

extension FavoritesController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == "") {
            self.isFiltering = false
        }
        else {
            self.filteredServicers = favoriteServicers.filter { (servicer) -> Bool in
                var contains = false
                let searchFormated = self.getFormatedString(entryString: searchText)
                
                let servicerName = self.getFormatedString(entryString: servicer.name!)
                let categoryName = self.getFormatedString(entryString: servicer.category!.name)
                
                contains = (servicerName.contains(searchFormated) || categoryName.contains(searchFormated))
                
                return contains
            }
            
            self.isFiltering = true
            self.tableView.reloadData()
        }
    }
    
    
    //method to nomalize string before compair
    func getFormatedString(entryString:String) -> String {
        let lowercase = entryString.lowercased()
        
        //removing accents and special character
        return lowercase.folding(options: .diacriticInsensitive, locale: .current)
    }
}

extension FavoritesController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.isFiltering) {
            return self.filteredServicers.count
        }
        return self.favoriteServicers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Servicer", for: indexPath) as! ServicerTableViewCell
        
        var currentServicer:Servicer
        
        if(isFiltering) {
            currentServicer = filteredServicers[indexPath.row]
        }
        else {
            currentServicer = favoriteServicers[indexPath.row]
        }
        
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
        
        if(currentServicer is EstablishmentServicer) {
            let estServicer = currentServicer as! EstablishmentServicer
            
            let distancyKm = estServicer.getKmDistance(fromPosition: self.currentLocation.coordinate)
            
            cell.servicerDistancy.text = String.init(format: "%.1f km", distancyKm)
            
            cell.servicerInfo.isHidden = false
            cell.servicerInfo.text = estServicer.isOpen() ? "OPEN".localized : "CLOSED".localized
            
        }
        else {
            cell.servicerDistancy.text = "WORKS_ON_AREA".localized
            cell.servicerInfo.isHidden = true
        }
        
        
        return cell
    }
    
}
