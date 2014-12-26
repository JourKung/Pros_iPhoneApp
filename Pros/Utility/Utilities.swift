//
//  Utilities.swift
//  Pros
//
//  Created by Suwat Saegauy on 11/7/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    class func titleLabelOnNavigationBar(title: String!) -> UIView {
        let label: UILabel = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont(name: "Helvetica-Bold", size: 17.0)
        label.textAlignment = NSTextAlignment.Center
        label.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        label.textColor = UIColor.blackColor()
        label.minimumScaleFactor = 0.5
        label.text = title
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        
        return label
    }
    
    class func roundCorners(view: UIView!, cornerRadius: CGFloat!, borderWidth: CGFloat!, color: UIColor!) -> UIView {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.layer.borderColor = color.CGColor
        view.layer.borderWidth = borderWidth
        
        return view
    }
    
    class func barButtonWithImage(image: UIImage!, target: AnyObject!, action: Selector!) -> UIBarButtonItem {
        let button: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.setBackgroundImage(image, forState: UIControlState.Normal)
        button.frame = CGRectMake(0, 0, image.size.width, image.size.height)
        
        if (target != nil) && (action != nil) {
            button.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        let item = UIBarButtonItem(customView: button)
        
        return item
    }
    
    class func integerWithNumber(number: NSNumber!) -> String {
        let numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.NoStyle
        var numberAsString: String! = numberFormatter.stringFromNumber(number)
        
        return numberAsString
    }
    
    class func decimalWithNumber(number: NSNumber!) -> String {
        let numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        var numberAsString: String! = numberFormatter.stringFromNumber(number.floatValue)
        
        return numberAsString
    }
    
    class func currencyWithNumber(number: NSNumber!) -> String {
        let numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        var numberAsString: String! = numberFormatter.stringFromNumber(number.floatValue)
        
        return numberAsString;
    }
}
