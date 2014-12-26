//
//  UserDefaults.swift
//  Pros
//
//  Created by Suwat Saegauy on 11/25/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

// ------------------------------
// MARK: -
// MARK: Nested struct
// ------------------------------

private let MySharedInstance = UserDefaults()

class UserDefaults {
    
    class var sharedInstance: UserDefaults {
        struct Static {
            static let instance = UserDefaults()
        }
        return Static.instance
    }
    
    init() {
        println("[Log] Singleton: Nested struct init")
    }
    
    var userObjectID = String()
    
    var userActivities = [String: AnyObject]()
}