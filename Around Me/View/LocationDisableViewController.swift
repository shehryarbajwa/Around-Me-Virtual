//
//  LocationDisableViewController.swift
//  Around Me
//
//  Created by Shehryar Bajwa on 2018-09-09.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit
import CoreLocation

class LocationDisableViewController: UIViewController {
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func Enabledisable(_ sender: Any) {
        let alert = UIAlertController(title: " Enable/Disable the location services", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Disable", style: .destructive) { (UIAlertAction) in
            let alert2 = UIAlertController(title: "Location tracking is disabled", message: "", preferredStyle: .alert)
            self.present(alert2 , animated: true , completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                alert2.dismiss(animated: true, completion: nil)
                self.locationManager.stopUpdatingLocation()
            })
        }
        alert.addAction(action)
        
        let action2 = UIAlertAction(title: "Enable", style: .destructive) { (UIAlertAction) in
            let alert2 = UIAlertController(title: "Location tracking is enabled", message: "", preferredStyle: .alert)
            self.present(alert2 , animated: true , completion: nil)
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                alert2.dismiss(animated: true, completion: nil)
                self.locationManager.startUpdatingLocation()
            })
        }
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
        
    }
    }



    


