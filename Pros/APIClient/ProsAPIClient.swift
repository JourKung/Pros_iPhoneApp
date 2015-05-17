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
        return (kBaseUrl)+(path)
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
    
    func postUserFacebookLoggedOutWithRevokeSession() -> Request {
        let aManager = Alamofire.Manager.sharedInstance
        aManager.session.configuration.HTTPAdditionalHeaders = [
            "X-Parse-Application-Id": kParseApplicationId,
            "X-Parse-REST-API-Key": kParseRESTAPIKey,
            "X-Parse-Session-Token": UserDefaults.sharedInstance.getUserSessionToken()]
        
        let path: String! = "\(kParseBaseUrl)/logout"
        return Alamofire.request(.POST, path, encoding: .JSON)
    }
    
    func postValidatingSessionToken() -> Request {
        let aManager = Alamofire.Manager.sharedInstance
        aManager.session.configuration.HTTPAdditionalHeaders = [
            "X-Parse-Application-Id": kParseApplicationId,
            "X-Parse-REST-API-Key": kParseRESTAPIKey,
            "X-Parse-Session-Token": UserDefaults.sharedInstance.getUserSessionToken()]
        
        let path: String! = "\(kParseBaseUrl)/users/me"
        return Alamofire.request(.POST, path, encoding: .JSON)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Promotions
    // ------------------------------
    
    func getPromotionWithCompletion() -> Request {
        let path: String! = "/list-promotions"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getPromotionDetailWithCompletion(form: PromotionDetailForm!) -> Request {
        let path: String! = "/look-for-promotion/\(form.fbId)/\(form.promotionId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getLikeByFbIdAndPromotionIdWithCompletion(form: LikeForm!) -> Request {
        let path: String! = "/is-like/\(form.fbId)/\(form.promotionId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getLikeToggleByFbIdAndPromotionIdWithCompletion(form: PromotionLikeToggleForm!) -> Request {
        let path: String! = "/toggle-like/\(form.fbId)/\(form.promotionId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getShareByFbIdAndPromotionIdWithCompletion(form: ShareForm!) -> Request {
        let path: String! = "/new-share/\(form.fbId)/\(form.promotionId)"
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
        let path: String! = "/list-shops-by-category/\(Utilities.percentEncodingWithUrl(parameter))"
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
    
    func getShopByShopIdWithCompletion(form: ShopForm!) -> Request {
        let path: String! = "/look-for-shop/\(form.shopId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getSubscribeByFbIdAndShopIdWithCompletion(form: SubscribeForm!) -> Request {
        let path: String! = "/is-subscribe/\(form.fbId)/\(form.shopId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getSubscribeToggleByFbIdAndShopIdWithCompletion(form: ShopSubscribeToggleForm!) -> Request {
        let path: String! = "/toggle-subscribe/\(form.fbId)/\(form.shopId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Feedback
    // ------------------------------
    
    func getFeedbackWithCompletion(form: FeedbackForm!) -> Request {
        let path: String! = "/get-feedback-form/\(form.shopId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func postSubmitFeedbackWithCompletion(form: SubmitFeedbackForm!) -> Request {
        let path: String! = "/submit-feedback"
        
        var parameters = defaultParametersAsDictionary()
        parameters["feedbackquestion_id"] = form.feedbackquestion_id
        parameters["facebook_id"] = form.facebook_id
        parameters["answer"] = form.answer
        
        return Alamofire.request(.POST, urlString(path), parameters: parameters)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Notification
    // ------------------------------
    
    func getNotificationWithCompletion(form: NotificationForm!) -> Request {
        let path: String! = "/list-feedly/\(form.fbId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Cards
    // ------------------------------
    
    func getInsertMembershipCardWithCompletion(form: InsertMembershipCardForm!) -> Request {
        let path: String! = "/create-membercard/\(form.fbId)/\(form.qrId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getMembershipCardWithCompletion(form: MembershipCardForm!) -> Request {
        let path: String! = "/list-membercards/\(form.fbId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    func getMembershipCardDetailWithCompletion(form: MembershipCardDetailForm!) -> Request {
        let path: String! = "/create-membercard/\(form.fbId)/\(form.shopId)"
        return Alamofire.request(.GET, urlString(path))
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Settings
    // ------------------------------
    
}
