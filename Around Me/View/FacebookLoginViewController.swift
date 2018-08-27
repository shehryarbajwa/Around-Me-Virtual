//
//  FacebookLoginViewController.swift
//  Aroundme
//
//  Created by Shehryar Bajwa on 2018-08-25.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import UIKit

class FacebookLoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("print")
    }
    @IBAction func dismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func maps(_ sender: Any) {
        if let token = FBSDKAccessToken.current(){
            self.performSegue(withIdentifier: "mapview", sender: self)
        } else {
            let alert = UIAlertController(title: "Please login via Facebook before accessing maps", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var login: FBSDKLoginButton!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       login.delegate = self
        
        if let token = FBSDKAccessToken.current(){
            fetchRequest()
            let alert = UIAlertController(title: "Logging in", message: "", preferredStyle: .alert)
            let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
            indicator.autoresizingMask = [.flexibleWidth , .flexibleHeight]
            indicator.activityIndicatorViewStyle = .gray
            alert.view.addSubview(indicator)
            indicator.isUserInteractionEnabled = false
            indicator.startAnimating()
            self.present(alert, animated:true)
            
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when) {
                alert.dismiss(animated: true, completion: { ()
                    self.performSegue(withIdentifier: "mapview", sender: self)
                })
            }
        }
        
    }
    
    func fetchRequest(){
        print("hello")
        var parameters = ["fields": "email, first_name, last_name, location"]
        
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: parameters).start { (connection, result, error) in
            if error != nil {
                print(error)
          }
            if let result = result as? [String:String]{
                let email : String = result["email"]!
                print(email)
                let firstname : String = result["first_name"]!
                let lastname: String = result["last_name"]!
                print(firstname)
                print(lastname)
            }
            
            
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        print("Hello")
        return true
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error != nil )){
            print(error)
        }
        else if result.isCancelled{
            self.dismiss(self)
        } else if (result.grantedPermissions != nil){
            self.performSegue(withIdentifier: "mapview", sender: self)
        } else if (result.declinedPermissions != nil){
            self.dismiss(self)
        }
    }
    
    



}
