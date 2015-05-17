//
//  NotificationTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/8/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var promotionTypeNameLabel: UILabel!
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionPublishedAtLabel: UILabel!
    
    @IBOutlet weak var shopLogoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.shopLogoImageView, cornerRadius: self.shopLogoImageView.frame.size.width/2, borderWidth: 0.0, color: .clearColor())
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
}
