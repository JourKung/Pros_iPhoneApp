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
    
    var objectId: String!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    
    var name: String!
    var detail: String!
    var termCondition: String!
    var coverImageUrl: String!
    var logoImageUrl: String!
    var coordinate: PFGeoPoint!
    
    var coverImage: UIImage!
    var logoImage: UIImage!
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(objectId: String, createdAt: NSDate, updatedAt: NSDate,
        name: String, detail: String, termCondition: String, coverImageUrl: String, logoImageUrl: String, coordinate: PFGeoPoint, coverImage: UIImage, logoImage: UIImage) {
            super.init()
            
            self.objectId = objectId
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            
            self.name = name
            self.detail = detail
            self.termCondition = termCondition
            self.coverImageUrl = coverImageUrl
            self.logoImageUrl = logoImageUrl
            self.coordinate = coordinate
            self.coverImage = coverImage
            self.logoImage = logoImage
    }
}
