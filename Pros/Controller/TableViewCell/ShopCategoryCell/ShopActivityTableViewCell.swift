//
//  ShopActivityTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/1/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

protocol ShopActivityTableViewCellDelegate {
    func getSubscribeStateToggleDelegate(cell: AnyObject)
}

class ShopActivityTableViewCell: UITableViewCell {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var shopLogoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.shopLogoImageView, cornerRadius: self.shopLogoImageView.frame.size.width/2, borderWidth: 0.0, color: UIColor.clearColor())
        }
    }
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var shopTypeNameLabel: UILabel!
    @IBOutlet weak var shopSubscribeButton: UIButton!

    var delegate: ShopActivityTableViewCellDelegate?
    var subscribeState: Bool! = false // Not subscribe by default
    
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
    
    @IBAction func subscribeToggle(sender: AnyObject) {
        self.delegate!.getSubscribeStateToggleDelegate(self)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func customSubscribeButton(button: UIButton!, title: String!, titleColor: UIColor!, borderColor: UIColor!) -> Void {
        button.setTitle(title, forState: .Normal)
        button.setTitleColor(titleColor, forState: .Normal)
        
        button.backgroundColor = UIColor.clearColor()
        button.layer.borderWidth = 1
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.layer.borderColor = borderColor.CGColor
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func unsubscribe() -> Void {
        // Set to unsubscribe
        self.subscribeState = false
        self.customSubscribeButton(self.shopSubscribeButton, title: "Subscribe", titleColor: UIColor.applicationTwitterLogoBlueColor(), borderColor: UIColor.applicationTwitterLogoBlueColor())
    }
    
    func subscribe() -> Void {
        // Set to subscribed
        self.subscribeState = true
        customSubscribeButton(self.shopSubscribeButton, title: "Subscribed", titleColor: UIColor.redColor(), borderColor: UIColor.redColor())
    }
}
