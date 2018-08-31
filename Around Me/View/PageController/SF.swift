//
//  Berlin.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-18.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class SF: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "SF")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBOutlet weak var loginInsta: UIButton!
    
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: "loginFB", sender: self)
        }
    }
