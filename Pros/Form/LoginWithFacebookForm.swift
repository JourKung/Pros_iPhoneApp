//
//  LoginWithFacebookForm.swift
//  Pros
//
//  Created by Suwat Saegauy on 4/3/2558 BE.
//  Copyright (c) 2558 com.cpekmutt.project. All rights reserved.
//

import UIKit

class LoginWithFacebookForm: NSObject {
    
    var profile: [String: AnyObject]!
    
    // authData
    var fbId: String!
    var accessToken: String!
    var expirationDate: String!
}
