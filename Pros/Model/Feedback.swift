//
//  Feedback.swift
//  Pros
//
//  Created by Suwat Saegauy on 5/1/2558 BE.
//  Copyright (c) 2558 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class Feedback: Mappable {
   
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var feedbackID: String?
    var shopID: String?
    var revision: String?
    var questionNo: String?
    var questionType: String?
    var question: String?
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    func mapping(map: Map) {
        self.feedbackID <- map["id"]
        self.shopID <- map["shopID"]
        self.revision <- map["revision"]
        self.questionNo <- map["questionNo"]
        self.questionType <- map["questionType"]
        self.question <- map["question"]
    }

}
