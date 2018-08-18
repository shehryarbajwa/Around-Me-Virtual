//
//  ImagesVC.swift
//  MapView
//
//  Created by Shehryar Bajwa on 2018-08-15.
//  Copyright © 2018 Shehryar. All rights reserved.
//


import UIKit
import MapKit
import CoreData

class ImageSelectorViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var updateButton: UIButton!
    
    static let shared = ImageSelectorViewController()
    
    var annotation: MKAnnotation?
    var annotation2 :MKAnnotation?
    var pin: Pin?
    var totalPages = 0
    var photos = [Photos]()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setUpViews()
    }
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let annotation = annotation{
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
        
        guard let photosArray = pin?.photo?.allObjects as? [Photos] else {return}
        self.photos = photosArray
        
        if photos.count == 0{
            loadImage()
        }
    }
    
    func loadImage(page: String? = nil){
        if let annotation = annotation{
            updateButton.isEnabled = false
            
            //Bbox will be used to locate the existing location of the pin
            
            let bbox =  "\(annotation.coordinate.longitude), \(annotation.coordinate.latitude), \(annotation.coordinate.longitude+1), \(annotation.coordinate.latitude+1)"
            
            FlickrClient.shared.getFlickrImages(bbox, page, { (total, photosDic, error) in
                if let _ = error{
                    print("error")
                    return
                }
                
                
                guard let total = total, let photosDic = photosDic else {return}
                self.totalPages = total
                
                guard let pin = self.pin else {return}
                CoreDataManager.share.insertPhotos(photosDic, pin)
                guard let photosArray = pin.photo?.allObjects as? [Photos] else {return}
                self.photos = photosArray
                DispatchQueue.main.async {
                    self.photos.count > 0 ? self.collectionView.reloadData(): self.showEmptyLabel()
                    self.updateButton.isEnabled = true
                }
            })
        }
    }
    
    func showEmptyLabel(){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        self.view.addSubview(label)
        label.text = "This pin has no image. Please select a different location"
        self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.label.heightAnchor.constraint(equalToConstant: 200).isActive = true
        self.label.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setUpViews(){
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        mapView.isUserInteractionEnabled = false
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        self.collectionView.reloadData()
    }
    
    func changeButtonLabel(){
        guard let count = collectionView.indexPathsForSelectedItems?.count else {return}
        if(count > 0){
            updateButton.setTitle("Remove Selected Pictures", for: .normal)
            return
        }
        
        updateButton.setTitle("New Collection", for: .normal)
    }
    
    @IBAction func updateCollectionView(_ sender: Any) {
        if (updateButton.titleLabel?.text == "New Collection"){
            
            if(CoreDataManager.share.removeObjects((pin?.photo?.allObjects as! [Photos]))){
                self.updateButton.isUserInteractionEnabled = false
                loadNewImages()
                self.updateButton.isUserInteractionEnabled = true
            }
            return
        }
        removeImage()
    }
    
    func loadNewImages(){
        self.photos.removeAll()
        self.collectionView.reloadData()
        let randomPage = Int(arc4random_uniform(UInt32(20)))
        loadImage(page: "\(randomPage)")
    }
    
    func removeImage(){
        guard let selectedIndexPaths = collectionView.indexPathsForSelectedItems else {return}
        var selectedPhotos = [Photos]()
        for index in selectedIndexPaths{
            selectedPhotos.append(photos[index.item])
            hightlightCell(index, highlighted: true)
            collectionView.deselectItem(at: index, animated: true)
        }
        
        if(CoreDataManager.share.removeObjects(selectedPhotos)){
            guard let photosArray = pin?.photo?.allObjects as? [Photos] else {return}
            self.photos = photosArray
            collectionView.reloadData()
            changeButtonLabel()
        }
    }
    
    @IBAction func returnToMapViewController(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
