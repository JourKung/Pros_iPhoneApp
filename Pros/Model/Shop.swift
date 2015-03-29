//
//  Shop.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class Shop: NSObject {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
//    var objectId: String!
//    var createdAt: NSDate!
//    var updatedAt: NSDate!
    
    var shopId: String!
    var name: String!
    var UserFirstName: String!
    var UserLastName: String!
    var email: String!
    var Username: String!
    var shopType: String!
    var UserTermCondition: String!
    var UserLogoImageUrl: String!
    var UserCoverImageUrl: String!
    var UserShopDescription: String!
    var UserLocationLat: String!
    var UserLocationLong: String!
    var Telephone: String!
    var ShopConcept: String!
    var created_at: String!
    var updated_at: String!
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(shopId: String!,
        name: String!,
        UserFirstName: String!,
        UserLastName: String!,
        email: String!,
        Username: String!,
        shopType: String!,
        UserTermCondition: String!,
        UserLogoImageUrl: String!,
        UserCoverImageUrl: String!,
        UserShopDescription: String!,
        UserLocationLat: String!,
        UserLocationLong: String!,
        Telephone: String!,
        ShopConcept: String!,
        created_at: String!,
        updated_at: String!) {
            
            super.init()
            
            self.shopId = shopId
            self.name = name
            self.UserFirstName = UserLastName
            self.UserLastName = UserLastName
            self.email = email
            self.Username = Username
            self.shopType = shopType
            self.UserTermCondition = UserTermCondition
            self.UserLogoImageUrl = UserLogoImageUrl
            self.UserCoverImageUrl = UserCoverImageUrl
            self.UserShopDescription = UserShopDescription
            self.UserLocationLat = UserLocationLat
            self.UserLocationLong = UserLocationLong
            self.Telephone = Telephone
            self.ShopConcept = ShopConcept
            self.created_at = created_at
            self.updated_at = updated_at
    }
}
