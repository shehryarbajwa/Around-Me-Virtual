//
//  CoreDataManager.swift
//  Mappaa
//
//  Created by Shehryar Bajwa on 2018-08-22.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager  {
    
    
    static let share = CoreDataManager()
    
    let persistentContainer : NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Mappaa")
        container.loadPersistentStores  { (storeDescription, err) in
            if let err = err {
                fatalError("failed to load the database : \(err)")
            }
        }
        return container
    }()
    
    func createPin(_ latitude : Double? , _ longitude : Double?)->(Pin? , String?){
        
    let context = CoreDataManager.share.persistentContainer.viewContext
    let pin = NSEntityDescription.insertNewObject(forEntityName: "Pin", into: context) as! Pin
        pin.latitude = latitude!
        pin.longitude = longitude!
        
        if saveContext(){
            return (pin , nil)
            print("Pin created")
        }
        
        return(nil, "Error to create Pin")
    }
    
    func fetchPins() ->[Pin]{
        let context = CoreDataManager.share.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        do {
            let pins = try context.fetch(fetchRequest)
            return pins
        } catch let error {
            print(error)
        }
        return [Pin]()
    }
    
    func removeObjects(_ objects: [NSManagedObject])->Bool{
        
        let context = CoreDataManager.share.persistentContainer.viewContext
        
        for object in objects{
            context.delete(object)
        }
        
        return saveContext()
    }
    
    func insertPhotos(_ photosDic: [[String:AnyObject]] , _ pin: Pin){
        
        let context = CoreDataManager.share.persistentContainer.viewContext
        
        for dic in photosDic{
            
            let photo = NSEntityDescription.insertNewObject(forEntityName: "Photos", into: context) as! Photos
            photo.flickrID = dic["id"] as? String
            photo.url = dic[FlickrAPI.ParameterKeys.MediumURL] as? String
            photo.pin = pin
            context.insert(photo)
        }
        _ = saveContext()
    }
    
    func fetchPins() -> [Photos]{
        let context = CoreDataManager.share.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Photos>(entityName: "Photos")
        
        do {
            let photos = try context.fetch(fetchRequest)
            return photos
        } catch let error {
            print(error)
        }
        return [Photos]()
    }
        
        
    
    func saveContext() -> Bool {
        
        let context = CoreDataManager.share.persistentContainer.viewContext
        
        do {
        if context.hasChanges{
            try context.save()
        }
        return true
    } catch let error {
        print(error)
    }
        return false
    }
    
}


