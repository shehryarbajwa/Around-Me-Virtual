//
//  Paris.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-18.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class NYC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage(named: "NYC")

    }
    @IBOutlet weak var LoginInsta: UIButton!
    
    @IBAction func loginInsta(_ sender: Any) {
         self.performSegue(withIdentifier: "loginFB", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
