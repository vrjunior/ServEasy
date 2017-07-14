//
//  SearchFilterViewController.swift
//  LocalCommerce
//
//  Created by João Agostinho Hergert on 06/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import UIKit

class SearchFilterViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        
        
        self.tableView.backgroundColor = .clear
        
        
        let rightButtonItem = UIBarButtonItem.init(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(rightButtonAction)
        )
        
        //action: #selector(addTapped)
        
        self.navigationItem.rightBarButtonItem = rightButtonItem


    }
    
    
    func rightButtonAction(sender: UIBarButtonItem){
    
        let newVC = SearchController()
        //self.navigationController?.pushViewController(newVC, animated: true)
        
        
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
                    return 10
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
        
        func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let headerView = view as? UITableViewHeaderFooterView {
                headerView.textLabel?.textAlignment = .center
                headerView.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightHeavy)
                headerView.textLabel?.textColor = UIColor.titleColor
            }
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            var cell: UITableViewCell
            
            switch (indexPath.section) {
            case 0:
                let categoryCell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath) as! CategoryFilterTableViewCell
                
                categoryCell.category.text = "alguma coisa"
                
                cell = categoryCell
            
            case 1:
                let ratingCell = tableView.dequeueReusableCell(withIdentifier: "rating", for: indexPath) as! RatingTableViewCell
                
                cell = ratingCell
                
            case 2:
                let localCell = tableView.dequeueReusableCell(withIdentifier: "local", for: indexPath) as! LocalTableViewCell
                
                cell = localCell
                
            case 3:
                let distanceCell = tableView.dequeueReusableCell(withIdentifier: "distance", for: indexPath) as! DistanceTableViewCell
            
            
                cell = distanceCell
                
                
            
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "filter", for: indexPath) as! CategoryFilterTableViewCell
            }

            
            
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
