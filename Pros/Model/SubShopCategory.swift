//
//  SubShopCategory.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class SubShopCategory: NSObject {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var objectId: String!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    
    
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(objectId: String, createdAt: NSDate, updatedAt: NSDate
        ) {
            super.init()
            
            self.objectId = objectId
            self.createdAt = createdAt
            self.updatedAt = updatedAt
    }
}
