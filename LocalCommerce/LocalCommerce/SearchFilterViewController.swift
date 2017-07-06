//
//  SearchFilterViewController.swift
//  LocalCommerce
//
//  Created by João Agostinho Hergert on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    extension SearchFilterViewController: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return array.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath) as! ProductTableViewCell
            
            //cell.productName.text = array[indexPath.row]
            
            
            return cell
        }
        
    }
