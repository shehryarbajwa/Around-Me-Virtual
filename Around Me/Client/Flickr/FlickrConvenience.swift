//
//  InstagramConvenience.swift
//  Mappaa
//
//  Created by Shehryar Bajwa on 2018-08-20.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation
import UIKit



extension FlickrClient{

    func flickrURL(_ extras:Bool? , _ bbox: String , _ page: String?) -> URL{
        
        var urlComponents = URLComponents()
        var queryitems = [URLQueryItem]()
        
        urlComponents.scheme = FlickrAPI.Flickr.ApiScheme
        urlComponents.host = FlickrAPI.Flickr.ApiHost
        urlComponents.path = FlickrAPI.Flickr.ApiPath
        
        queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.method, value: FlickrAPI.ParameterKeys.SearchMethod))
        queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.apikey, value: FlickrAPI.ParameterKeys.APIkey))
        queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.bbox, value: bbox))
        queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.format, value: FlickrAPI.ParameterKeys.ResponseFormat))
        queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.nojsoncallback, value: FlickrAPI.ParameterKeys.NOJSONCallback))
        queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.safesearch, value: FlickrAPI.ParameterKeys.Safesearch))
        queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.perpage, value: "20"))
        
        if (extras == true){
            queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.extras, value: FlickrAPI.ParameterKeys.MediumURL))
        }
        
        if let page = page {
            queryitems.append(URLQueryItem(name: FlickrAPI.JSONParameters.page, value: page))
        }

        urlComponents.queryItems = queryitems
        return urlComponents.url!
        print(urlComponents.url!)
        
    }
    
    
    func taskforGetMethod(_ url:URL , _ completionhandlerforget: @escaping (_ data: Data?,_ error: Error?) -> Void){
        
        let task = URLSession.shared
        
        task.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned an error other than 2xx")
                return
            }
            
            if (statusCode == 200){
                completionhandlerforget(data, nil)
            }
            
        }
        .resume()
    }
    
    func getFlickrImages(_ bbox:String , _ page: String?=nil , _ completionhandlerfordownload : @escaping (_ totalPages: Int?, _ photosdictionary : [[String:AnyObject]]? , _ error: Error?)->Void){
        
        let url = flickrURL(true, bbox, page)
        let urlrequest = URLRequest(url: url)
        
        taskforGetMethod(url) { (data, error) in
            
            do{
                if let error = error{
                    completionhandlerfordownload(nil, nil, error as NSError)
                }
                
            guard let data = data else{return}
            
                guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject],
            let photosdictionary = json["photos"] as? [String:AnyObject] ,
            let totalpages = photosdictionary["total"] as? String ,
                let photo = photosdictionary["photo"] as? [[String:AnyObject]] else {return}
                
                print(photo)
            
            guard let total = Int(totalpages) else {return}
            completionhandlerfordownload(total , photo, nil)
            
            } catch let error {
                print(error)
            }
        }
    }
    
   
    
    
    
}
