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
    
    var locationManager: CLLocationManager = CLLocationManager()
    var currentLocation: CLLocation = CLLocation()
    
    var favoriteServicers = [Servicer]()
    var favoriteAccessLayer = FavoriteAccessLayer()
    
    override func viewDidLoad() {
        self.locationManager.delegate = self
        self.locationManager.requestLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.favoriteServicers = self.favoriteAccessLayer.getFavoritesServicers()
        self.tableView.reloadData()
    }
    
}

extension FavoritesController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}


extension FavoritesController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favoriteServicers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Servicer", for: indexPath) as! ServicerTableViewCell
        
        let currentServicer = favoriteServicers[indexPath.row]
        
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
