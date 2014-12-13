//
//  Menu.swift
//  Pros
//
//  Created by Suwat Saegauy on 11/25/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

@objc
class Menu {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    let title: String
    let description: String
    let image: UIImage?
    
    init(title: String, description: String, image: UIImage?) {
        self.title = title
        self.description = description
        self.image = image
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------

    class func allMenu() -> Array<Menu> {
        return [Menu(title: "News", description: "Feeds", image: UIImage(named: "image1")),
            Menu(title: "My cards", description: "Membership card", image: UIImage(named: "image1")),
            Menu(title: "Categories", description: "Shop categories", image: UIImage(named: "image1")),
            Menu(title: "Settings", description: "System setting", image: UIImage(named: "image1")),
            Menu(title: "Logout", description: "", image: UIImage(named: "image1"))];
    }
}

