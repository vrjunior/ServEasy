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
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var addressIcon: UIImageView!
    public var myMapLocation : CLLocationCoordinate2D?
    public var currentServicer:Servicer?
    
    let favoriteAccessLayer = FavoriteAccessLayer()
    var isFavorite: Bool = false
    
    let topImages:[UIImage?] = []
    
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
            print(servicer.rating!)
            self.getImages()
            
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
    
    func getImages(){
        if let urls = self.currentServicer?.facadeImages {
            
            var xOffset:CGFloat = 0
            
            for imageUrl in urls{
                self.pageControl.currentPage = 0
                self.pageControl.numberOfPages = urls.count
                
                if let url = URL(string: imageUrl) {
                    URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) -> Void in
                        
                        if error != nil {
                            print(String(describing:error))
                            return
                        }
                        
                        // a imagem recebida presica ser preenchida na main queue
                        DispatchQueue.main.async(execute: { () -> Void in
                            if let currentImage = UIImage(data: data!) {
                                
                                let imageView = UIImageView(image: currentImage)
                                
                                imageView.center = CGPoint(x:  self.view.frame.width / 2, y: self.imageScrollView.frame.height / 2)
                                
                                print(imageView.center)
                                
                                self.imageScrollView.addSubview(imageView)
                                
                                imageView.frame = (imageView.frame.offsetBy(dx: xOffset, dy: 0))
                                
                                
                                xOffset += self.view.frame.width
                                
                                self.imageScrollView.contentSize = CGSize(width: xOffset, height: (imageView.frame.height))
                                
                                
                            }
                        })
                        
                    }).resume()
                }

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

extension ServicerController: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calcula o numero da página baseado no quanto o scrollview está deslocado em X
        let page = floor(scrollView.contentOffset.x / self.view.frame.width)
        
        // Para atualizar o current page é necessário converter o float para Int
        pageControl.currentPage = Int(page)
    }
    
}
