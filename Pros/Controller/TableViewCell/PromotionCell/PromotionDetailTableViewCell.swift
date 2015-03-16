//
//  PromotionDetailTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/23/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class PromotionDetailTableViewCell: UITableViewCell {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var expiredDate: UILabel!
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.logoImageView, cornerRadius: self.logoImageView.frame.size.width/2, borderWidth: 0.0, color: .clearColor())
        }
    }
    @IBOutlet weak var promotionImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.promotionImageView, cornerRadius: 5.0, borderWidth: 0.0, color: .clearColor())
        }
    }
    
    private var likeState: Bool! = false
    
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
    // MARK: Action
    // ------------------------------
    
    @IBAction func likeToggle(sender: AnyObject) {
        self.likeState = !self.likeState
        
        if (self.likeState == true) {
            like()
        } else {
            unlike()
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    private func unlike() -> Void {
        self.likeButton.setImage(UIImage(named: "00_heart"), forState: .Normal)
    }
    
    private func like() -> Void {
        self.likeButton.setImage(UIImage(named: "01_heart"), forState: .Normal)
    }

}
