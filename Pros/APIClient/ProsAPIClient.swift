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
    
    private func urlString(path: String!) -> String! {
        return (kDevBaseUrl)+(path)
    }
   
    // ------------------------------
    // MARK: -
    // MARK: Activities
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: User authentication
    // ------------------------------
    
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
