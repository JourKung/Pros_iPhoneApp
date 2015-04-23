//
//  Shop.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class Shop: Mappable {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
//    var objectId: String!
//    var createdAt: NSDate!
//    var updatedAt: NSDate!
    
    var shopID: String!
    var name: String?
    var email: String?
    var shopType: String?
    var description: String?
    var address: String?
    var latitude: String?
    var longitude: String?
    var tel: String?
    var logoImageURL: String?
    var coverImageURL: String?
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.shopID <- map["id"]
        self.name <- map["name"]
        self.email <- map["email"]
        self.shopType <- map["shopType"]
        self.description <- map["description"]
        self.address <- map["address"]
        self.latitude <- map["latitude"]
        self.longitude <- map["longitude"]
        self.tel <- map["tel"]
        self.logoImageURL <- map["logoImageURL"]
        self.coverImageURL <- map["coverImageURL"]
    }
}
