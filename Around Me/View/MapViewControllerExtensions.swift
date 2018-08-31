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
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {return}
        
        var currentlocation = true
        
        var searchlocation = true
        
        
        if (currentlocation){
            if mapView.showsUserLocation == true {
            guard let annotation2 = (view.annotation?.coordinate.latitude.isEqual(to: (currentlocationannotation2?.latitude)!)) else {
                    currentlocation == false
                    return
            }
            guard let annotation3 = (view.annotation?.coordinate.longitude.isEqual(to: (currentlocationannotation2?.longitude)!)) else {
                    currentlocation == false
                    return
            }
            
            if (annotation2 == true && annotation3 == true){
            print("dog")
            let alert = UIAlertController(title: "Please drop a pin closeby to see what people are sharing", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated:true)
            } else {
                print("User location not shared")
                self.performSegue(withIdentifier: "imagesVC", sender: view)
                }
            }
            else if (!editmode) {
                self.performSegue(withIdentifier: "imagesVC", sender: view)
                }
            else{
                mapView.deselectAnnotation(annotation, animated: true)
                removePin(annotation)
            }
            }
    }
    
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
