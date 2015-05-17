//
//  Card.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class Card: Mappable {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var id: String!
    var shopID: String?
    var userID: String?
    var publishAt: String?
    var expireAt: String?
    var extendAt: String?
    var point: String?
    var shopName: String?
    var shopLogoURL: String?
    var shopCoverURL: String? //TOP
    var shopType: String?
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.shopID <- map["shopID"]
        self.userID <- map["userID"]
        self.publishAt <- map["publishAt"]
        self.expireAt <- map["expireAt"]
        self.extendAt <- map["extendAt"]
        self.point <- map["point"]
        self.shopName <- map["shopName"]
        self.shopLogoURL <- map["shopLogoURL"]
        self.shopCoverURL <- map["shopCoverURL"]
        self.shopType <- map["shopType"]
    }
}
