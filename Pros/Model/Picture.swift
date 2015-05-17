//
//  Picture.swift
//  Pros
//
//  Created by Suwat Saegauy on 4/5/2558 BE.
//  Copyright (c) 2558 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

struct Picture: Mappable {
    
    var celcius: Double?
    var fahrenheit: Double?
    
    init(){}
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    mutating func mapping(map: Map) {
        celcius     <- map["celcius"]
        fahrenheit  <- map["fahrenheit"]
    }
    
    /*
    enum Router: URLRequestConvertible {
        static let baseURLString = "https://api.500px.com/v1"
        static let consumerKey = "PASTE_YOUR_CONSUMER_KEY_HERE"
        
        case PopularPhotos(Int)
        case PhotoInfo(Int, ImageSize)
        case Comments(Int, Int)
        
        var URLRequest: NSURLRequest {
            let (path: String, parameters: [String: AnyObject]) = {
                switch self {
                case .PopularPhotos (let page):
                    let params = ["consumer_key": Router.consumerKey, "page": "\(page)", "feature": "popular", "rpp": "50",  "include_store": "store_download", "include_states": "votes"]
                    return ("/photos", params)
                case .PhotoInfo(let photoID, let imageSize):
                    var params = ["consumer_key": Router.consumerKey, "image_size": "\(imageSize.rawValue)"]
                    return ("/photos/\(photoID)", params)
                case .Comments(let photoID, let commentsPage):
                    var params = ["consumer_key": Router.consumerKey, "comments": "1", "comments_page": "\(commentsPage)"]
                    return ("/photos/\(photoID)/comments", params)
                }
                }()
            
            let URL = NSURL(string: Router.baseURLString)
            let URLRequest = NSURLRequest(URL: URL!.URLByAppendingPathComponent(path))
            let encoding = Alamofire.ParameterEncoding.URL
            
            return encoding.encode(URLRequest, parameters: parameters).0
        }
    }
    */
    
    enum ImageSize: Int {
        case Tiny = 1
        case Small = 2
        case Medium = 3
        case Large = 4
        case XLarge = 5
    }
}
