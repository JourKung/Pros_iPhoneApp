//
//  ShopCategoryTableViewCell.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/25/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class ShopCategoryTableViewCell: UITableViewCell {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeImageView: UIImageView!
    /*
    {
        didSet {
            Utilities.roundCornersWithImageView(self.typeImageView, cornerRadius: 4.0, borderWidth: 0.0, color: .clearColor())
        }
    }*/

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
