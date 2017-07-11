//
//  ServicerController.swift
//  LocalCommerce
//
//  Created by Rafael Sol Santos Martins on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit
import CoreLocation

class ServicerController : UIViewController {
    
    
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
    
    @IBOutlet weak var addressIcon: UIImageView!
    public var myMapLocation : CLLocationCoordinate2D?
    public var currentServicer:Servicer?
    
    @IBAction func budgetButton(_ sender: Any) {
        
    }
    

    
    override func viewDidLoad() {
        if let servicer = currentServicer {
            print(servicer.name!)
            self.servicerName.text = servicer.name
            self.servicerPhone.text = servicer.phone
            self.servicerRate.text = String(describing: servicer.rating!)
            print(servicer.rating!)
            if servicer is EstablishmentServicer{
                let eServicer = servicer as! EstablishmentServicer
                self.servicerAdress.text = eServicer.addressStreet
                self.servicerCity.text = eServicer.addressCity
                self.servicerCategory.text = eServicer.category?.name
                
                
                if let mapLocation = myMapLocation{
                    let distanceKm = eServicer.getKmDistance(fromPosition: mapLocation)
                    self.servicerTimeDistance.text = String(format: "DISTANCE_MSG".localized, distanceKm)
                }
                
            }else if servicer is NonEstablishmentServicer{
                let neServicer = servicer as! NonEstablishmentServicer
                
                self.addressIcon.isHidden = true
                self.servicerAdress.isHidden = true
                self.servicerCity.isHidden = true
                
                
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
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
}
