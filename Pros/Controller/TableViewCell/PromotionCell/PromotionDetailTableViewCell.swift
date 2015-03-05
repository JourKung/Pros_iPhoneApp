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
    
    private var likeState: Bool! = false
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var releasedDate: UILabel!
    @IBOutlet weak var expiredDate: UILabel!
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.logoImageView, cornerRadius: 4.0, borderWidth: 0.0, color: .clearColor())
        }
    }
    @IBOutlet weak var promotionImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.promotionImageView, cornerRadius: 4.0, borderWidth: 0.0, color: .clearColor())
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
    // MARK: Action
    // ------------------------------
    
    @IBAction func like(sender: AnyObject) {
        likeState = !likeState
        
        if (likeState == true) {
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
