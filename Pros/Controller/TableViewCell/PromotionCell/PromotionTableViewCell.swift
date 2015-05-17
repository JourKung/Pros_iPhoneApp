//
//  PromotionTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/23/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var whiteView: UIView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopTypeNameButton: UIButton!
    @IBOutlet weak var promotionNameLabel: UILabel!
    @IBOutlet weak var promotionTypeNameLabel: UILabel!
    @IBOutlet weak var promotionPublishedAtLabel: UILabel!
    @IBOutlet weak var promotionTypeImageView: UIImageView!
    @IBOutlet weak var promotionImageView: UIImageView!
    @IBOutlet weak var promotionLikeButton: UIButton!
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

    override func layoutSubviews() {
        cardSetup()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func cardSetup() -> Void {
        self.whiteView.layer.masksToBounds = false
        self.whiteView.layer.cornerRadius = 2//1 // if you like rounded corners
        self.whiteView.layer.shadowOffset = CGSizeMake(-0.2, 0.2) //%%% this shadow will hang slightly down and to the right
        self.whiteView.layer.shadowRadius = 0.8 //%%% I prefer thinner, subtler shadows, but you can play with this
        self.whiteView.layer.shadowOpacity = 0.1 //%%% same thing with this, subtle is better for me
        
        //%%% This is a little hard to explain, but basically, it lowers the performance required to build shadows.  If you don't use this, it will lag
        let path: UIBezierPath! = UIBezierPath(rect: self.whiteView.bounds)
        self.whiteView.layer.shadowPath = path.CGPath
        self.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) //%%% I prefer choosing colors programmatically than on the storyboard
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func likeToggle(sender: AnyObject) {
        /*
        self.likeState = !self.likeState

        if (self.likeState == true) {
            like()
        } else {
            unlike()
        }
        */
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
}
