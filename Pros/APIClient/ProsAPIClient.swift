//
//  ProsAPIClient.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/16/2558 BE.
//  Copyright (c) 2558 com.cpekmutt.project. All rights reserved.
//

import UIKit
import Alamofire

class ProsAPIClient: NSObject {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    private func urlString(path: String!) -> String! {
        return (kDevBaseUrl)+(path)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func defaultParametersAsDictionary() -> [String: AnyObject]! {
        let params: [String: AnyObject]! = [String: AnyObject]()
        return params
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Activities
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: User authentication
    // ------------------------------    
    
    func postUserFacebookRegister(form: LoginWithFacebookForm!) -> Request {
        let aManager = Alamofire.Manager.sharedInstance
        aManager.session.configuration.HTTPAdditionalHeaders = [
            "X-Parse-Application-Id": kParseApplicationId,
            "X-Parse-REST-API-Key": kParseRESTAPIKey,
            "X-Parse-Revocable-Session": "1"]
        
        let parameters: [String: AnyObject]! = ["authData": [
            "facebook": [
                "id": form.fbId,
                "access_token": form.accessToken,
                "expiration_date": form.expirationDate]
            ]
        ]
        
        let path: String! = "\(kParseBaseUrl)/users"
        return Alamofire.request(.POST, path, parameters: parameters, encoding: .JSON)
    }
    
    func putUserFacebookProfile(form: LoginWithFacebookForm!) -> Request {
        let aManager = Alamofire.Manager.sharedInstance
        aManager.session.configuration.HTTPAdditionalHeaders = [
            "X-Parse-Application-Id": kParseApplicationId,
            "X-Parse-REST-API-Key": kParseRESTAPIKey,
            "X-Parse-Session-Token": UserDefaults.sharedInstance.getUserSessionToken()]
        
        var parameters = defaultParametersAsDictionary()
        parameters["profile"] = form.profile
        
        let path: String! = "\(kParseBaseUrl)/users/\(UserDefaults.sharedInstance.getUserObjectId())"
        return Alamofire.request(.PUT, path, parameters: parameters, encoding: .JSON)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Promotions
    // ------------------------------
    
    func getPromotionsWithCompletion() -> Request {
        let path: String! = "/list-promotions"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getPromotionDetailWithCompletion(fbId: String!, promotionId: String!) -> Request {
        let path: String! = "/look-for-promotion/\(fbId)/\(promotionId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Categories
    // ------------------------------
    
    func getCategoriesWithCompletion() -> Request {
        let path: String! = "/list-categories"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getSubCategoriesByTypeWithCompletion(parameter: String!) -> Request {
        let path: String! = "/list-shops-by-category/\(Utilities.cleanUrl(parameter))"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getSubCategoriesWithCompletion() -> Request {
        let path: String! = "/list-shops"
        return Alamofire.request(.GET, urlString(path))
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Shop
    // ------------------------------
    
    func getShopByShopIdWithCompletion(parameter: String!) -> Request {
        let path: String! = "/look-for-shop/\(parameter)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getSubscribeByFbIdAndShopIdWithCompletion(fbId: String!, shopId: String!) -> Request {
        let path: String! = "/is-subscribe/\(fbId)/\(shopId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getToggleSubscribeByFbIdAndShopIdWithCompletion(fbId: String!, shopId: String!) -> Request {
        let path: String! = "/toggle-subscribe/\(fbId)/\(shopId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Notification
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: Cards
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: Settings
    // ------------------------------
    
}
