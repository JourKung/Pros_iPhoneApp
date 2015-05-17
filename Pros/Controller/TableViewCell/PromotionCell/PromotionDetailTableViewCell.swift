//
//  PromotionDetailTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/23/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import TTTAttributedLabel

protocol PromotionDetailTableViewCellDelegate {
    func getLikeToggleDelegate(cell: AnyObject)
}

class PromotionDetailTableViewCell: UITableViewCell {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    /*
    let label: TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    label.font = UIFont.systemFontOfSize(14)
    label.textColor = UIColor.darkGrayColor()
    label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    label.numberOfLines = 0
    */
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopTypeNameLabel: UILabel!
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionDescriptionLabel: TTTAttributedLabel!
    @IBOutlet weak var promotionTypeNameLabel: UILabel!
    @IBOutlet weak var promotionExpiredDate: UILabel!
    @IBOutlet weak var promotionImageView: UIImageView!
    @IBOutlet weak var promotionTypeImageView: UIImageView!
    @IBOutlet weak var promotionLikeButton: UIButton!
    @IBOutlet weak var shopLogoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.shopLogoImageView, cornerRadius: self.shopLogoImageView.frame.size.width/2, borderWidth: 0.0, color: .clearColor())
        }
    }
    
    var delegate: PromotionDetailTableViewCellDelegate?
    var likeState: Bool! = false // Not subscribe by default
    
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
        self.delegate!.getLikeToggleDelegate(self)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func unlike() -> Void {
        // Set to unlike
        self.likeState = false
        self.promotionLikeButton.setImage(UIImage(named: "00_icon_heart"), forState: .Normal)
    }
    
    func like() -> Void {
        // Set to like
        self.likeState = true
        self.promotionLikeButton.setImage(UIImage(named: "00_icon_heart-1"), forState: .Normal)
    }

}
