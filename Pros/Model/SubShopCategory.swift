//
//  SubShopCategory.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class SubShopCategory: Mappable {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
//    var objectId: String!
//    var createdAt: NSDate!
//    var updatedAt: NSDate!
    
    var shopID: String!
    var title: String?
    var type: String?
    var logoImageUrl: String?
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.shopID <- map["id"]
        self.title <- map["name"]
        self.type <- map["shopType"]
        self.logoImageUrl <- map["UserLogoImageUrl"]
    }
}
