//
//  Singleton.swift
//  Pros
//
//  Created by Suwat Saegauy on 10/19/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit

private let MySharedInstance_Singleton = Dispatch_once()
private let MySharedInstance_NestedStruct = Nested_struct()

// ------------------------------
// MARK: -
// MARK: dispatch_once
// ------------------------------

class Dispatch_once {
    class var sharedInstance: Dispatch_once {
    struct Static {
        static var instance: Dispatch_once? = nil
        static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Dispatch_once()
        }
        return Static.instance!
    }
    
    init() {
        println("[Singleton] dispatch_once init")
    }
    
}

// ------------------------------
// MARK: -
// MARK: Nested struct
// ------------------------------

class Nested_struct {
    class var sharedInstance: Nested_struct {
        struct Static {
            static let instance = Nested_struct()
        }
        return Static.instance
    }
    
    init() {
        println("[Singleton] Nested struct init")
    }
    
    var userObjectID = String()
    var userActivities = [String: AnyObject]()
}

