//
//  Utilities.swift
//  Pros
//
//  Created by Suwat Saegauy on 11/7/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

class Utilities: NSObject {
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    class func titleLabelOnNavigationBar(title: String!) -> UIView {
        let label: UILabel = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor.clearColor()
        label.font = UIFont(name: "AvenirNext-Regular", size: 17.0)
        label.textAlignment = NSTextAlignment.Center
        label.lineBreakMode = NSLineBreakMode.ByTruncatingMiddle
        label.textColor = UIColor.darkGrayColor()
        label.minimumScaleFactor = 0.5
        label.text = title
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        
        return label
    }
    
    class func roundCornersWithView(view: UIView!, cornerRadius: CGFloat!, borderWidth: CGFloat!, color: UIColor!) -> UIView {
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
        view.layer.borderColor = color.CGColor
        view.layer.borderWidth = borderWidth
        view.clipsToBounds = true
        
        return view
    }
    
    class func roundCornersWithImageView(imageView: UIImageView!, cornerRadius: CGFloat!, borderWidth: CGFloat!, color: UIColor!) -> UIImageView {
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = color.CGColor
        imageView.layer.borderWidth = borderWidth
        imageView.clipsToBounds = true
        
        return imageView
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
        let numberAsString: String! = numberFormatter.stringFromNumber(number)
        
        return numberAsString
    }
    
    class func decimalWithNumber(number: NSNumber!) -> String {
        let numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let numberAsString: String! = numberFormatter.stringFromNumber(number.floatValue)
        
        return numberAsString
    }
    
    class func currencyWithNumber(number: NSNumber!) -> String {
        let numberFormatter: NSNumberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        let numberAsString: String! = numberFormatter.stringFromNumber(number.floatValue)
        
        return numberAsString
    }
    
    class func dateWithString(date: NSDate!, dateStype: NSDateFormatterStyle!, timeStyle: NSDateFormatterStyle!) -> String {
        let formatter: NSDateFormatter! = NSDateFormatter()
        formatter.dateStyle = dateStype
        formatter.timeStyle = timeStyle
        let dateAsString = formatter.stringFromDate(date)
        
        return dateAsString
    }
}


