//
//  TableView.swift
//  Around Me
//
//  Created by Shehryar Bajwa on 2018-09-09.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit

let list = ["User Agreement" , "Privacy Policy", "Location Services Update"]
var myIndex = 0

class TableViewClass : UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func dismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex = indexPath.row
        if myIndex == 0 {
            performSegue(withIdentifier: "EULA", sender: self)
        } else if myIndex == 1{
            performSegue(withIdentifier: "Privacy", sender: self)
        } else {
            performSegue(withIdentifier: "LocationServices", sender: self)
        }
        
    }
    
    
    
    
    
    
    
    
}
