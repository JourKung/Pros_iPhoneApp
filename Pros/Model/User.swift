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
    
    var objectId: String
    var createdAt: NSDate
    var updatedAt: NSDate
    
    var fbId: String
    var name: String
    var email: String
    var profileImageUrl: String
    var birthday: String
    var gender: String
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    init(objectId: String, createdAt: NSDate, updatedAt: NSDate, fbId: String, name: String, email: String, profileImageUrl: String, birthday: String, gender: String) {
        
        self.objectId = objectId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
        self.fbId = fbId
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.birthday = birthday
        self.gender = gender
    }
}