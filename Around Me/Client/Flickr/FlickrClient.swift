//
//  InstagramClient.swift
//  Mappaa
//
//  Created by Shehryar Bajwa on 2018-08-19.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit


class FlickrClient: NSObject{
    
    static let shared = FlickrClient()
    
    var pins = [Pin]()
    var session = URLSession.shared
    //var imagesDictionary = [NSDictionary]
    var imagesArray = [String]()
    //var images = NSSet()
    
    var accesstoken: String? = nil
    
    func URLFromParameters (_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL{
        
        var components = URLComponents()
        
        components.scheme = FlickrAPI.Flickr.ApiScheme
        components.host = FlickrAPI.Flickr.ApiHost
        components.path = FlickrAPI.Flickr.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryitems = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryitems)
        }
        return components.url!
    }
    
    func taskforGetMethod(_ method: String, _ parameters : [String:AnyObject]? , _ completionhandlerforget: @escaping (_ result: AnyObject? , _ error: Error?) -> Void) -> URLSessionDataTask {
        
        var parameters = parameters
        
        var url = URLFromParameters(parameters!, withPathExtension: method)
        
        var request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil)else {
                print("Error : \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a statusCode other than 2xx")
                return
            }
            
            guard let data = data else {
                print("No data was returned by your request")
                return
            }
            
           self.convertDatawithJSON(data, completionhandlerforget)
            
            
        }
            task.resume()
        
        return task
        }
    
    func taskforPostMethod(_ method: String?, _ parameters: [String:AnyObject]?, _ jsonBody: String, _ completionhandler: @escaping (_ results: AnyObject? , _ error: Error?) ->Void)->URLSessionDataTask{
        
        var parameters = parameters
        
        var url = URLFromParameters(parameters!, withPathExtension: method!)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard (error == nil) else {
                print("Error : \(error)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a statusCode other than 2xx")
                return
            }
            
            guard let data = data else {
                print("No data was returned by your request")
                return
            }
            
            self.convertDatawithJSON(data, completionhandler)
        }
        task.resume()
        
        return task
        
        }
    
    fileprivate func convertDatawithJSON(_ data: Data? , _ completionhandlerforJSON: @ escaping (_ result: AnyObject?, _ error:Error?)->Void){
        
        var parsedResult : AnyObject!
        
        do {
            parsedResult = (try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? AnyObject?)!
        } catch {
            let userinfo = [NSLocalizedDescriptionKey: "Couldnot parse the data as JSON : \(data)" ]
            completionhandlerforJSON(nil, NSError(domain: "convertDatawithcompletionhandler", code: 0, userInfo: userinfo))
        }
        
        completionhandlerforJSON(parsedResult , nil)
        
    }
    
    
    
    
    
    }
