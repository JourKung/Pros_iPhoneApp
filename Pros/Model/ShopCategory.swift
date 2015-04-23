//
//  ShopCategory.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class ShopCategory: Mappable {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
//    var objectId: String!
//    var createdAt: NSDate!
//    var updatedAt: NSDate!
    
    var shopType: String!
    var typeIconURL: String?
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    init(shopType: String!, typeIconURL: String?) {
        self.shopType = shopType
        self.typeIconURL = typeIconURL
    }
    
    func mapping(map: Map) {
        self.shopType <- map["shopType"]
        self.typeIconURL <- map["typeIconURL"]
    }
}
