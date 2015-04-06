//
//  UserDefaults.swift
//  Pros
//
//  Created by Suwat Saegauy on 11/25/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

// ------------------------------
// MARK: -
// MARK: Nested struct
// ------------------------------

private let MySharedInstance = UserDefaults()

private let USERDEVICETOKEN         = "userDeviceToken"
private let USERSESSIONTOKEN        = "userSessionToken"

private let USERFBID                = "userFbId"
private let USERFBACCESSTOKEN       = "userFbAccessToken"
private let USERFBEXPIRATIONDATE    = "userFbExpirationDate"

private let USEROBJECTID            = "userObjectId"
private let USERNAME                = "username"
private let USERGENDER              = "userGender"
private let USERBIRTHDAY            = "userBirthday"
private let USEREMAIL               = "userEmail"
private let USERPROFILEIMAGEDATA    = "userProfileImageData"

class UserDefaults {
    
    class var sharedInstance: UserDefaults {
        struct Static {
            static let instance = UserDefaults()
        }
        return Static.instance
    }
    
    init() {
        println("[UserDefaults] Nested struct init")
    }
    
    var userActivities: User?
    
    func setObject(object: AnyObject!, dictionary: String!) -> Void {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (object != nil) {
            defaults.setObject(object, forKey: dictionary)
        } else {
            defaults.removeObjectForKey(dictionary)
        }
        
        defaults.synchronize()
    }
    
    func objectForKey(dictionary: String!) -> AnyObject! {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(dictionary)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: MEMEMTO: GETTER
    // ------------------------------
    
    func getUserDeviceToken() -> String! {
        return objectForKey(USERDEVICETOKEN) as? String
    }
    
    func getUserSessionToken() -> String! {
        return objectForKey(USERSESSIONTOKEN) as? String
    }
    
    func getUserFbId() -> String! {
        return objectForKey(USERFBID) as? String
    }
    
    func getUserFbAccessToken() -> String! {
        return objectForKey(USERFBACCESSTOKEN) as? String
    }
    
    func getUserFbExpirationDate() -> NSDate! {
        return objectForKey(USERFBEXPIRATIONDATE) as? NSDate
    }
    
    func getUserObjectId() -> String! {
        return objectForKey(USEROBJECTID) as? String
    }
    
    func getUsername() -> String! {
        return objectForKey(USERNAME) as? String
    }
    
    func getUserGender() -> String! {
        return objectForKey(USERGENDER) as? String
    }
    
    func getUserBirthday() -> String! {
        return objectForKey(USERBIRTHDAY) as? String
    }
    
    func getUserEmail() -> String! {
        return objectForKey(USEREMAIL) as? String
    }
    
    func getUserProfileImageData() -> NSData! {
        return objectForKey(USERPROFILEIMAGEDATA) as? NSData
    }
    
    // ------------------------------
    // MARK: -
    // MARK: MEMEMTO: SETTER
    // ------------------------------
    
    func setUserDeviceToken(userDeviceToken: String?) {
        setObject(userDeviceToken, dictionary: USERDEVICETOKEN)
    }
    
    func setUserSessionToken(userSessionToken: String!) {
        setObject(userSessionToken, dictionary: USERSESSIONTOKEN)
    }
    
    func setUserFbId(userFbId: String!) {
        setObject(userFbId, dictionary: USERFBID)
    }
    
    func setUserFbAccessToken(userFbAccessToken: String!) {
        setObject(userFbAccessToken, dictionary: USERFBACCESSTOKEN)
    }
    
    func setUserFbExpirationDate(userFbExpirationDate: NSDate!) {
        setObject(userFbExpirationDate, dictionary: USERFBEXPIRATIONDATE)
    }
    
    func setUserObjectId(userObjectId: String!) {
        setObject(userObjectId, dictionary: USEROBJECTID)
    }
    
    func setUsername(username: String!) {
        setObject(username, dictionary: USERNAME)
    }
    
    func setUserGender(userGender: String!) {
        setObject(userGender, dictionary: USERGENDER)
    }
    
    func setUserBirthday(userBirthday: String) {
        setObject(userBirthday, dictionary: USERBIRTHDAY)
    }
    
    func setUserEmail(userEmail: String) {
        setObject(userEmail, dictionary: USEREMAIL)
    }
    
    func setUserProfileImageData(userProfileImageData: NSData!) {
        setObject(userProfileImageData, dictionary: USERPROFILEIMAGEDATA)
    }
}



