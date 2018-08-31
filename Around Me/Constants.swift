//
//  Constants.swift
//  Mappaa
//
//  Created by Shehryar Bajwa on 2018-08-19.
//  Copyright © 2018 Shehryar. All rights reserved.
//

import Foundation

class FlickrAPI{
    
    static let shared = FlickrAPI()
    
    
    struct Flickr{
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
    }
    
    struct JSONParameters {
        static let method = "method"
        static let apikey = "api_key"
        static let bbox = "bbox"
        static let extras = "extras"
        static let format = "format"
        static let perpage = "per_page"
        static let page = "page"
        static let nojsoncallback = "nojsoncallback"
        static let safesearch = "safe_search"
    }
    
    struct ParameterKeys {
        static let SearchMethod = "flickr.photos.search"
        static let APIkey = "a9804ab5fe025e7da40882c49c7b486b"
        static let ResponseFormat = "json"
        static let NOJSONCallback = "1"
        static let MediumURL = "url_m"
        static let PerPage = 20
        static let Safesearch = "1"
    }
}
