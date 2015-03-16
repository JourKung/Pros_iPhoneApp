//
//  ShopActivityTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/1/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class ShopActivityTableViewCell: UITableViewCell {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.logoImageView, cornerRadius: self.logoImageView.frame.size.width/2, borderWidth: 0.0, color: UIColor.clearColor())
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var subscribeButton: UIButton! {
        didSet {
            if (self.subscribeState == true) {
                subscribe()
            } else {
                unsubscribe()
            }
        }
    }
    
    private var subscribeState: Bool! = false // Unsubscribe default
    
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
        self.subscribeState = !self.subscribeState
        
        if (self.subscribeState == true) {
            subscribe()
        } else {
            unsubscribe()
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customSubscribeButton(button: UIButton!, title: String!, titleColor: UIColor!, borderColor: UIColor!) -> Void {
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
    
    private func unsubscribe() -> Void {
        // Set to unsubscribe
        customSubscribeButton(self.subscribeButton, title: "Subscribe", titleColor: tintColor, borderColor: tintColor)
    }
    
    private func subscribe() -> Void {
        // Set to subscribed
        customSubscribeButton(self.subscribeButton, title: "Subscribed", titleColor: UIColor.redColor(), borderColor: UIColor.redColor())
    }
}
