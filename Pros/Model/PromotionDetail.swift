//
//  PromotionDetail.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/18/2558 BE.
//  Copyright (c) 2558 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class PromotionDetail: Mappable {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var promotionID: String!
    var point: String?
    var name: String?
    var type: String?
    var description: String?
    var publishedAt: String?
    var expiredAt: String?
    var poster: String?
    var discount: String?
    var stampMax: String?
    var campaignMax: String?
    var qrID: String?
    
    var shopID: String!
    var shopName: String?
    var shopImageURL: String?
    var shopType: String?
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.promotionID <- map["promotionID"]
        self.point <- map["point"]
        self.name <- map["name"]
        self.type <- map["type"]
        self.description <- map["description"]
        self.publishedAt <- map["publishedAt"]
        self.expiredAt <- map["expiredAt"]
        self.poster <- map["poster"]
        self.discount <- map["discount"]
        self.stampMax <- map["stampMax"]
        self.campaignMax <- map["campaignMax"]
        self.qrID <- map["qrID"]
        
        self.shopID <- map["shopID"]
        self.shopName <- map["shopName"]
        self.shopImageURL <- map["shopImageURL"]
        self.shopType <- map["shopType"]
    }
}
