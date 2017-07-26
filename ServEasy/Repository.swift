//
//  Repository.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import Foundation

class Repository {
    static var server:String = "http://localhost:3000/"
    
    
    func parseJSONFromData(jsonData: Data?) -> [String: AnyObject]?
    {
        if let data = jsonData {
            do {
                let jsonDictionary =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: AnyObject]
                return jsonDictionary
            } catch let error {
                print("Error processing json data: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}
