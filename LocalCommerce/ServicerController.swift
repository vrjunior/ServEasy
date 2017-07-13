//
//  ServicerController.swift
//  LocalCommerce
//
//  Created by Rafael Sol Santos Martins on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import GoogleMaps

class ServicerController : UIViewController {
    
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var servicerImage: UIImageView!
    @IBOutlet weak var servicerLogo: UIImageView!
    @IBOutlet weak var servicerName: UILabel!
    @IBOutlet weak var servicerCategory: UILabel!
    @IBOutlet weak var servicerRate: UILabel!
    @IBOutlet weak var servicerAdress: UILabel!
    @IBOutlet weak var servicerPhone: UILabel!
    @IBOutlet weak var servicerTimeDistance: UILabel!
    @IBOutlet weak var servicerCity: UILabel!
    @IBOutlet weak var servicerIsOpen: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var viewTabbar: UIView!
    
    @IBOutlet weak var addressIcon: UIImageView!
    public var myMapLocation : CLLocationCoordinate2D?
    public var currentServicer:Servicer?
    
    let favoriteAccessLayer = FavoriteAccessLayer()
    var isFavorite: Bool = false
    
    @IBAction func budgetButton(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        
        
        //check if servicer is favorite
        self.isFavorite = self.favoriteAccessLayer.isServicerFavorite(id: self.currentServicer!.id!)
        if(isFavorite) {
            self.favoriteButton.image = UIImage(named: "favoriteFilled")
        }
        
        if let servicer = currentServicer {
            self.servicerName.text = servicer.name
            self.servicerPhone.text = servicer.phone
            self.servicerRate.text = String(describing: servicer.rating!)
            
            if servicer is EstablishmentServicer{
                let eServicer = servicer as! EstablishmentServicer
                self.servicerAdress.text = eServicer.addressStreet
                self.servicerCity.text = eServicer.addressCity
                self.servicerCategory.text = eServicer.category?.name
                
                
                if let mapLocation = myMapLocation{
                    let distanceKm = eServicer.getKmDistance(fromPosition: mapLocation)
                    self.servicerTimeDistance.text = String(format: "DISTANCE_MSG".localized, distanceKm)
                }
                
                self.updateMapView(location: eServicer.location!)
                
            }else if servicer is NonEstablishmentServicer{
                let neServicer = servicer as! NonEstablishmentServicer
                
                self.addressIcon.removeFromSuperview()
                self.servicerAdress.removeFromSuperview()
                self.servicerCity.removeFromSuperview()
                
                self.mapView.removeFromSuperview()
                
                
                self.servicerTimeDistance.text = "\(servicer.name ?? "") works on your area"
                var cities:String = String()
                
                if let servedCities = neServicer.servedCities {
                    if let servedUFCities = neServicer.servedUFCities{
                        
                        for i in 0 ..< servedUFCities.count{
                            cities += servedCities[i] + " - " + servedUFCities[i]
                            if i < servedUFCities.count - 1{
                                cities += ", "
                            }
                        }
                        
                    }
                    
                }
                self.servicerTimeDistance.text = cities
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func updateMapView(location: CLLocationCoordinate2D) {
        //disabling interaction with map
        self.mapView.isUserInteractionEnabled = false
        
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
        
        //setting camera
        self.mapView.camera = GMSCameraPosition(target: location, zoom: 16, bearing: 0, viewingAngle: 0)
        
        //creating and setting marker
        let marker: GMSMarker = GMSMarker(position: location)
        marker.icon = self.currentServicer?.category?.getMarkerIcon()
        marker.title = self.currentServicer?.name
        marker.snippet = self.currentServicer?.category?.name
        
        marker.map = self.mapView
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func onTapFavoriteButton(_ sender: UIBarButtonItem) {
        if(isFavorite) {
            let formartedMsg = String.init(format: "UNFAVORITE_ALERT_MSG".localized, self.currentServicer!.name!)
            
            let alert = UIAlertController(title: "UNFAVORITE_ALERT_TITLE".localized, message: formartedMsg, preferredStyle: .actionSheet)
        
            alert.addAction(UIAlertAction(title: "CANCEL".localized, style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "UNFAVORITE".localized, style: .destructive, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    self.favoriteAccessLayer.unfavoriteServicer(byId: self.currentServicer!.id!)
                    self.favoriteButton.image = UIImage(named: "favorite")
                    self.isFavorite = false
                }
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            self.favoriteAccessLayer.favoriteServicer(byId: self.currentServicer!.id!)
            self.favoriteButton.image = UIImage(named: "favoriteFilled")
            self.isFavorite = true
        }
    }
    
    
    
    
}
