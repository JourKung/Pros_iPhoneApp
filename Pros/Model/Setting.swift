//
//  Setting.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class Setting: NSObject {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var objectId: String!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    
    var version: String!
    var pushNoti: Bool!
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(objectId: String, createdAt: NSDate, updatedAt: NSDate,
        version: String, pushNoti: Bool) {
            super.init()
            
            self.objectId = objectId
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            
            self.version = version
            self.pushNoti = pushNoti
    }
}
