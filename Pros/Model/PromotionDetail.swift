//
//  PromotionDetail.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/18/2558 BE.
//  Copyright (c) 2558 com.cpekmutt.project. All rights reserved.
//

import UIKit

class PromotionDetail: NSObject {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    //    var objectId: String!
    //    var createdAt: NSDate!
    //    var updatedAt: NSDate!
    
    var promotionID: String!
    var UserID: String!
    var promotionPublishPoint: String!
    var promotionPublishName: String!
    var promotionPublishType: String!
    var promotionPublishDescription: String!
    var promotionPublishPoster: String!
    var qrID: String!
    var promotionPublishCreatedAt: String!
    var promotionPublishUpdatedAt: String!
    var promotionPublishPublishedAt: String!
    var promotionPublishExpiredAt: String!
    var shopName: String!
    var shopLogoURL: String!
    var shopType: String!
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(promotionID: String!,
        UserID: String!,
        promotionPublishPoint: String!,
        promotionPublishName: String!,
        promotionPublishType: String!,
        promotionPublishDescription: String!,
        promotionPublishPoster: String!,
        qrID: String!,
        promotionPublishCreatedAt: String!,
        promotionPublishUpdatedAt: String!,
        promotionPublishPublishedAt: String!,
        promotionPublishExpiredAt: String!,
        shopName: String!,
        shopLogoURL: String!,
        shopType: String!) {
            
            super.init()
            
            self.UserID = UserID
            self.promotionPublishPoint = promotionPublishPoint
            self.promotionPublishName = promotionPublishName
            self.promotionPublishType = promotionPublishType
            self.promotionPublishDescription = promotionPublishDescription
            self.promotionPublishPoster = promotionPublishPoster
            self.qrID = qrID
            self.promotionPublishCreatedAt = promotionPublishCreatedAt
            self.promotionPublishUpdatedAt = promotionPublishUpdatedAt
            self.promotionPublishPublishedAt = promotionPublishPublishedAt
            self.promotionPublishExpiredAt = promotionPublishExpiredAt
            self.shopName = shopName
            self.shopLogoURL = shopLogoURL
            self.shopType = shopType
    }

}
