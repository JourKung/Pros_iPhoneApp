//
//  User.swift
//  Pros
//
//  Created by Suwat Saegauy on 10/30/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

class User: NSObject {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var objectId: String!
    var createdAt: NSDate!
    var updatedAt: NSDate!
    
    var fbId: String!
    var name: String!
    var gender: String!
    var birthday: String!
    var email: String!
//    var profileImageUrl: String!
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(objectId: String, createdAt: NSDate, updatedAt: NSDate,
        fbId: String, name: String, gender: String, birthday: String?, email: String?) {
            super.init()
            
            self.objectId = objectId
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            
            self.fbId = fbId
            self.name = name
            self.gender = gender
            self.birthday = birthday
            self.email = email
//            self.profileImageUrl = profileImageUrl
    }
}