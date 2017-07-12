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

    }
    
    
        
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    extension SearchFilterViewController: UITableViewDelegate, UITableViewDataSource {
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 4
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            switch (section) {
                case 0:
                    return 6
                case 1:
                    return 1
                case 2:
                    return 1
                case 3:
                    return 1
                default:
                    return 0
            }

        }
        
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var cell: UITableViewCell
            
            
            switch (indexPath.section) {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath) as! SearchFilterTableViewCell
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "distance", for: indexPath) as! SearchFilterTableViewCell
            case 2:
                cell = tableView.dequeueReusableCell(withIdentifier: "local", for: indexPath) as! SearchFilterTableViewCell
            case 3:
                cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath) as! SearchFilterTableViewCell
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath) as! SearchFilterTableViewCell
            }

            
            //cell.category.text = "TsT" + String(indexPath.section)
            return cell
        }

        
        
        
        
        func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            
            switch (section) {
            case 0:
                return "Serviços"
            case 1:
                return "Avaliação"
            case 2:
                return "Local"
            case 3:
                return "Serviço"
            default:
                return "..."
            }
            
            
        }
        
        
        
        
        
    }
