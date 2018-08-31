//
//  ViewController.swift
//  Mappaa
//
//  Created by Shehryar Bajwa on 2018-08-17.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class Rome: UIViewController {
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "Rome")
        
        
    }

    @IBOutlet weak var LoginInsta: UIButton!
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: "loginFB", sender: self)
        }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
    


