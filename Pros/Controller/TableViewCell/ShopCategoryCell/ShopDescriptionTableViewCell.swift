//
//  ShopDescriptionTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/1/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class ShopDescriptionTableViewCell: UITableViewCell {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.logoImageView, cornerRadius: self.logoImageView.frame.size.width/2, borderWidth: 0.0, color: .clearColor())
        }
    }
    @IBOutlet weak var coverImageView: UIImageView! {
        didSet {
            self.coverImageView.contentMode = UIViewContentMode.ScaleAspectFill
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

}
