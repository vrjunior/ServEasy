//
//  CommerceRepository.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 29/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation
import CoreLocation

class ServicerRepository: Repository {
    func getServicersByLocation(location: CLLocationCoordinate2D, radius: Double) -> [Servicer] {
        
        var services: [Servicer] = [Servicer]()
        
        let jsonFile = Bundle.main.path(forResource: "services", ofType: "json")
        let jsonData = NSData(contentsOfFile: jsonFile!)
        
        if let jsonDictionary = self.parseJSONFromData(jsonData: jsonData as Data?) {
            
            
            let estServiceDictionaries = jsonDictionary["EstablishmentServicer"] as! [[String: AnyObject]]
            
            
            for esDictionary in estServiceDictionaries {
                let establishmentService = EstablishmentServicer()
                
                establishmentService.name = esDictionary["name"] as? String!
                establishmentService.phone = esDictionary["phone"] as? String!
                establishmentService.rating = esDictionary["rating"] as? Float!
                establishmentService.thumbnailUrl = esDictionary["thumbnailUrl"] as? String!
                
                
                //TODO remove this force unwraper
                let categoryDic = esDictionary["category"] as! [String:AnyObject]
                let categoryId = categoryDic["id"] as! Int
                let categoryName = categoryDic["name"] as! String
                establishmentService.category = Category(id: categoryId, name: categoryName)
                
                let llatitude = esDictionary["locationLatitude"] as? Double!
                let llongitude = esDictionary["locationLongitude"] as? Double!
                establishmentService.setLocation(latitude: llatitude!, longitude: llongitude!)
                
                
                establishmentService.addressStreet = esDictionary["addressStreet"] as? String!
                establishmentService.addressNumber = esDictionary["addressNumber"] as? Int!
                establishmentService.addressCity = esDictionary["addressCity"] as? String!
                establishmentService.addressUF = esDictionary["addressUF"] as? String!
                
                services.append(establishmentService)
            }
            
            let nonEstServiceDictionaries = jsonDictionary["NonEstablishmentServicer"] as! [[String: AnyObject]]
            
            for nesDictionary in nonEstServiceDictionaries{
                let nonEstablishmentService = NonEstablishmentServicer()
                
                nonEstablishmentService.name = nesDictionary["name"] as? String!
                nonEstablishmentService.phone = nesDictionary["phone"] as? String!
                nonEstablishmentService.rating = nesDictionary["rating"] as? Float!
                nonEstablishmentService.thumbnailUrl = nesDictionary["thumbnailUrl"] as? String!
                
                let categoryDic = nesDictionary["category"] as! [String:AnyObject]
                let categoryId = categoryDic["id"] as! Int
                let categoryName = categoryDic["name"] as! String
                nonEstablishmentService.category = Category(id: categoryId, name: categoryName)
                
              
                //essas duas linhas tenho ctz que estao erradas!
                
                nonEstablishmentService.servedCities?.append((nesDictionary["addressCity"] as? String!)!)
                nonEstablishmentService.servedUFCities?.append((nesDictionary["addressUF"] as? String!)!)
                
                services.append(nonEstablishmentService)
            }
            
            
        }
        
        return services
    }
    
    func getServicesReviews(commerceId: Int) -> [Review] {
        
        return [Review]()
    }    
    
}
