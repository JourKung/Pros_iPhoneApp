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
    
//    var objectId: String!
//    var createdAt: NSDate!
//    var updatedAt: NSDate!
    
    var shopId: String!
    var title: String!
    var type: String!
    var logoImageUrl: String!
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(type: String, shopId: String, title: String, logoImageUrl: String!) {
        
            super.init()
            
            self.shopId = shopId
            self.title = title
            self.type = type
            self.logoImageUrl = logoImageUrl
    }
}
