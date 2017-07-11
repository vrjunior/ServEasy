//
//  FavoriteAccessLayer.swift
//  LocalCommerce
//
//  Created by vrjunior on 11/07/17.
//  Copyright © 2017 Valmir Junior. All rights reserved.
//

import CoreData
import UIKit

class FavoriteAccessLayer {

    let context = CoreDataManager.shared.persistentContainer.viewContext
    
    public func favoriteServicer(byId id:Int) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: managedContext)!
        
        let favorite = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        favorite.setValue(id, forKeyPath: "idServicer")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    public func isServicerFavorite(id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        let predicate = NSPredicate(format: "idServicer == %ld", id)
        fetchRequest.predicate = predicate
        do {
            let fetchResults =  try self.context.fetch(fetchRequest) as? [NSManagedObject]
            if fetchResults!.count > 0 {
                return true
            }
        }
        catch let error {
            print(error)
        }
        return false
    }
    
    public func unfavoriteServicer(byId id:Int) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
        let predicate = NSPredicate(format: "idServicer == %ld", id)
        fetchRequest.predicate = predicate
        do {
            let fetchResults =  try self.context.fetch(fetchRequest) as? [NSManagedObject]
            if let objects = fetchResults {
                for object in objects {
                    self.context.delete(object)
                }
            }
        }
        catch let error {
            print(error)
        }
                
    }
    
    
}
