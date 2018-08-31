//
//  MapViewController.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-22.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate {
    //Create outlets for all buttons
    @IBOutlet weak var searchBar: UIBarButtonItem!
    
    @IBOutlet weak var stopbutton: UIBarButtonItem!
    
    @IBOutlet weak var location: UIBarButtonItem!
    
    
    //Fetch pins from CoreData and initialize LocationManager
    var pins = [Pin]()
    var editmode = false
    var currentlocationmod = false
    private let locationManager = CLLocationManager()
    
    var currentlocationannotation2: CLLocationCoordinate2D?
    var searchlocationannotation : CLLocationCoordinate2D?
    
    private var currentLocation:CLLocationCoordinate2D?
    
    var currentlocationannotation : MKAnnotation? = nil
    
    
    @IBOutlet weak var mapView: MKMapView!
    var maptype: MKMapType = MKMapType.standard
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self 
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(addPins)))
        configureLocationServices()
        mapView.isZoomEnabled = true
        pins = CoreDataManager.share.fetchPins()
        insertPins()
        locationManager.startUpdatingLocation()
        guard let currentlocationforstart = currentLocation else {return}
        zoomtolatestcoordinate(currentlocationforstart)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func currentLocation(_ sender: Any) {
        
        guard let currentloc = currentLocation else {return}
        
        
        zoomtolatestcoordinate(currentloc)
    }
    
    private func configureLocationServices(){
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status  == .notDetermined{
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            print("Showing location")
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    
    private func zoomtolatestcoordinate(_ coordinate:CLLocationCoordinate2D){
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 50000, 50000)
        print(coordinate)
        print("showing updates")
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    private func beginlocationupdates(_ locationManager: CLLocationManager){
        
    }
    
    @IBAction func searchButton(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        
        //Hide search bar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //Create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil
            {
                print("ERROR")
            }
            else
            {
                //Remove annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //Getting data
                let latitude = response?.boundingRegion.center.latitude
                let longitude = response?.boundingRegion.center.longitude
                
                //Create annotation
                let annotation = MKPointAnnotation()
                annotation.title = searchBar.text
                annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                
                
                
                
                //Zooming in on annotation
                let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
                let span = MKCoordinateSpanMake(0.1, 0.1)
                let region = MKCoordinateRegionMake(coordinate, span)
                self.mapView.setRegion(region, animated: true)
            }
            
        }
    }
    
    
    
    
    
    
    @IBAction func editing(_ sender: Any) {
        editmode = !editmode
        var yValue: CGFloat = 5
        
        yValue = editmode ? self.mapView.frame.origin.y-74 : self.mapView.frame.origin.y+74
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.mapView.frame.origin.y = yValue
            
            if (self.editmode == true){
                self.navigationItem.rightBarButtonItem?.title = "Done"
                self.searchBar.isEnabled = false
                self.stopbutton.isEnabled = false
                self.location.isEnabled = false
                self.mapView.showsUserLocation = false
            }
            else {
                self.navigationItem.rightBarButtonItem?.title = "Edit"
                self.searchBar.isEnabled = true
                self.stopbutton.isEnabled = true
                self.location.isEnabled = true
                self.mapView.showsUserLocation = true
            }
        })
    }
    
    @objc func addPins(_ tap:UIGestureRecognizer){
        
        if (tap.state == .began){
            let point = tap.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            let annotations = MKPointAnnotation()
            annotations.coordinate = coordinate
            mapView.addAnnotation(annotations)
            
            
            let create = CoreDataManager.share.createPin(Double(coordinate.latitude), Double(coordinate.longitude))
            
            guard let pin = create.0 else {
                return
            }
            
            
            pins.append(pin)
            
        }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
            if segue.identifier == "imagesVC" {
                let destination = segue.destination as! ImageSelectorViewController
                guard let annotationView = sender as? MKAnnotationView else {return}
                guard let annotation = annotationView.annotation else {return}
                guard let pin = getPins(annotation) else {return}
                
              destination.annotation = annotationView.annotation
              destination.pin = pin
            }
        }
    
    
}

extension MapViewController : CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let latestLocations = locations.first else {return}
        
        if currentLocation == nil{
            zoomtolatestcoordinate(latestLocations.coordinate)
        }
        
        currentLocation = latestLocations.coordinate
        currentlocationannotation2 = latestLocations.coordinate
        print(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            
            print("authorization calling in real helper class")
            switch status {
                
            case CLAuthorizationStatus.notDetermined:
                
                configureLocationServices()
                
            case CLAuthorizationStatus.restricted:
                
                print("Restricted Access to location")
                self.locationManager.stopUpdatingLocation()
                
            case CLAuthorizationStatus.denied:
                
                print("User denied access to location")
                self.locationManager.stopUpdatingLocation()
                
            case CLAuthorizationStatus.authorizedWhenInUse:
                
                self.locationManager.startUpdatingLocation()
                
            default:
                
                print("default authorization")
            }
        }
        //
    }
    
    
    
    
}
