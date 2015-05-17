//
//  FeedbackViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/28/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

protocol FeedbackViewControllerDelegate {
    func feedbackWithAlertController(message: String!, rating: String!)
}

class FeedbackViewController: BaseViewController {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.logoImageView, cornerRadius: self.logoImageView.frame.width/2, borderWidth: 3.0, color: UIColor.whiteColor())
        }
    }
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var delegate: FeedbackViewControllerDelegate?
    var questionString: String!
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(0.9, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: nil, animations: {
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            self.dialogView.transform = CGAffineTransformConcat(scale, translate)
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func feelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {
            self.sendFeedbackEvenToStatisticWithTags(sender.tag)
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func setupView() -> Void {
        customNavigationBar()
        blurringEffect()
        combiningScaleAndTranslateTrnsforms()
        
        self.questionLabel.text = self.questionString
    }
    
    func customNavigationBar() -> Void {
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func sendFeedbackEvenToStatisticWithTags(tag: Int!) -> Void {
        switch (tag) {
        case 1:
            self.delegate!.feedbackWithAlertController("Bad", rating: "1")
        case 2:
            self.delegate!.feedbackWithAlertController("Medium", rating: "2")
        case 3:
            self.delegate!.feedbackWithAlertController("Good", rating: "3")
        default:
            self.delegate!.feedbackWithAlertController("Error", rating: "0")
        }
    }
    
    func blurringEffect() -> Void {
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.backgroundImageView.addSubview(blurEffectView)
    }
    
    func combiningScaleAndTranslateTrnsforms() -> Void {
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        dialogView.transform = CGAffineTransformConcat(scale, translate)
    }
}
