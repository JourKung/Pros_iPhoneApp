//
//  ProsHTTPClient.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/16/2558 BE.
//  Copyright (c) 2558 com.cpekmutt.project. All rights reserved.
//

import Foundation
import Alamofire

enum ProsHTTPClient: URLStringConvertible {
    case Method(Alamofire.Method)
    case BasicAuth(String, String)
    
    var URLString: String {
        let baseURLString = "http://httpbin.org/"
        let path: String = {
            switch self {
            case .Method(let method):
                return "/\(method.rawValue.lowercaseString)"
            case .BasicAuth(let user, let password):
                return "/basic-auth/\(user)/\(password)"
            }
            }()
        
        return NSURL(string: path, relativeToURL: NSURL(string: baseURLString))!.absoluteString!
    }
}
