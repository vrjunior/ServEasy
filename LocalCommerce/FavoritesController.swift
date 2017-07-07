//
//  WishlistController.swift
//  LocalCommerce
//
//  Created by Valmir Junior on 27/06/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit


var array = ["Moscow", "Saint Petersburg", "Novosibirsk"]



class FavoritesController: UIViewController {
    

    
}



extension FavoritesController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Servicer", for: indexPath) as! ProductTableViewCell
        
        cell.productName.text = array[indexPath.row]
        
        
        return cell
    }
    
}
