//
//  User.swift
//  Pros
//
//  Created by Suwat Saegauy on 10/30/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class User: Mappable {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var objectId: String!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    
    var fbId: String?
    var name: String?
    var gender: String?
    var birthday: String?
    var email: String?
    var profileImageUrl: String?
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    // Mappable
    func mapping(map: Map) {
        self.objectId <- map["objectId"]
        self.createdAt <- (map["createdAt"], DateTransform())
        self.updatedAt <- map["updatedAt"]
        
        self.fbId <- map["id"]
        self.name <- map["name"]
        self.gender <- map["gender"]
        self.birthday <- map["birthday"]
        self.email <- map["email"]
        self.profileImageUrl <- map[""]
    }
}