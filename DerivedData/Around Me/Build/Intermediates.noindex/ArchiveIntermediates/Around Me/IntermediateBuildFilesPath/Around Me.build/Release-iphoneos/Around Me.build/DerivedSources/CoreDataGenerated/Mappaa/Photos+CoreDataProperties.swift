//
//  Photos+CoreDataProperties.swift
//  
//
//  Created by Shehryar Bajwa on 2018-08-29.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var flickrID: String?
    @NSManaged public var image: Data?
    @NSManaged public var url: String?
    @NSManaged public var pin: Pin?

}
