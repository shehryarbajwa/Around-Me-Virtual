//
//  MapViewControllerExtensions.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-23.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController{
    
    
    
    func removePin(_ annotation: MKAnnotation){
        guard let pin = getPins(annotation) else {return}
        if (CoreDataManager.share.removeObjects([pin])){
            mapView.removeAnnotation(annotation)
        }
    }
    
    func getPins(_ annotation : MKAnnotation)-> Pin?{
        for pin in pins {
            if pin.latitude == Double(annotation.coordinate.latitude) && pin.longitude == Double(annotation.coordinate.longitude){
                return pin
            }
        }
        return nil
    }
    
    
    func insertPins(){
        
        var annotations = [MKAnnotation]()
        
        for pin in pins {
            let latitude = CLLocationDegrees(pin.latitude)
            let longitude = CLLocationDegrees(pin.longitude)
            let coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            var annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotations.append(annotation)
            
        }
        mapView.addAnnotations(annotations)
    }
    
    
    
    
    
    
    
}
