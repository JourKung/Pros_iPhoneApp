//
//  Singleton.swift
//  Pros
//
//  Created by Suwat Saegauy on 10/19/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit

private let MySharedInstance = Singleton()

class Singleton {
    class var sharedInstance: Singleton {
        
    struct Static {
        static var instance: Singleton? = nil
        static var onceToken: dispatch_once_t = 0
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = Singleton()
        }
        return Static.instance!
    }
    
    init() {
        println("[+] Singleton: init");
    }
}