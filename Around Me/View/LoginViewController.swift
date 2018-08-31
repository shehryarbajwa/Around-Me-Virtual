//
//  LoginViewController.swift
//  Mappaa
//
//  Created by Shehryar Bajwa on 2018-08-19.
//  Copyright © 2018 Shehryar. All rights reserved.
//
import Foundation
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    var reachability: Reachability?
    var accessToken: String? = nil
    var urlRequest: URLRequest? = nil
    var completionHandlerForView: ((_ success: Bool, _ errorString: String?) -> Void)? = nil
    var authenticated = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        print("no success")
        
        let alert = UIAlertController(title: "Logging In", message: "", preferredStyle: .alert)
        
        
        let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        alert.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            }
        
        
        self.reachability = Reachability.init()
        
        //cancel notification for function
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAuth))
    }
    
    
    @objc func cancelAuth(){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("no")
        super.viewWillAppear(true)
        print("loading is on")
        
         if let urlRequest = urlRequest {
        
            if ((reachability!.connection) == .none){
                
                self.activityView.stopAnimating()
                print("Internet connection failed")
                let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the Internet", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .destructive) { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                self.present(alert , animated: true)
               
            } else {
                self.activityView.isHidden = false
                webView.loadRequest(urlRequest)
            }
        }
    }
}

    
extension LoginViewController: UIWebViewDelegate {
        
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        self.activityView.isHidden = true
        let url = request.url
        var key: String
        var value : String
        if (url?.fragment != nil) {
            
            
            key = (url?.fragment?.components(separatedBy: "=").first)!
            print(key)
            value = (url?.fragment?.components(separatedBy: "=").last)!
            if key == "access_token"{
                accessToken = value
                print(value)
                
                InstagramClient.shared.accesstoken = accessToken
                self.activityView.isHidden = true
            }
            
            
        }
        
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let urlString = ("https://www.instagram.com#access_token=\(accessToken)")
        let alert = UIAlertController(title: "Logging In", message: "", preferredStyle: .alert)
        
        
        let indicator = UIActivityIndicatorView(frame: alert.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth , .flexibleHeight]
        alert.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false
        indicator.startAnimating()
        
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: {() in
                self.performSegue(withIdentifier: "mapview", sender: self)
            })
        }
        
        
        if webView.request!.url!.absoluteString == "https://www.instagram.com/" {
            self.present(alert, animated: true , completion: nil)
        }
        
        
        
        
        
    }

    
    
    
}
    
    
    

