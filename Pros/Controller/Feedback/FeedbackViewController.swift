//
//  FeedbackViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/28/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

protocol FeedbackViewControllerDelegate {
    func feedbackWithAlertController(message: String!)
}

class FeedbackViewController: BaseViewController {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var logoImageView: UIImageView! {
        didSet {
            Utilities.roundCornersWithImageView(self.logoImageView, cornerRadius: self.logoImageView.frame.width/2, borderWidth: 3.0, color: UIColor.whiteColor())
        }
    }
    
    var delegate: FeedbackViewControllerDelegate?
    weak var logoImage: UIImage! = UIImage()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customUI()
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
    
    private func customUI() -> Void {
        customNavigationBar()
        blurringEffect()
        combiningScaleAndTranslateTrnsforms()
        
        self.logoImageView.image = self.logoImage
    }
    
    private func customNavigationBar() -> Void {
    }
    
    private func updateUI() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    private func loadData() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    private func sendFeedbackEvenToStatisticWithTags(tag: Int!) -> Void {
        switch (tag) {
        case 1:
            println("[+] Send Bad")
        case 2:
            println("[+] Send Medium")
        case 3:
            println("[+] Send Good")
        default:
            println("[-] Cannot detect tag of button")
        }
        
        self.delegate!.feedbackWithAlertController("Thank you for submitted")
    }
    
    private func blurringEffect() -> Void {
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        self.backgroundImageView.addSubview(blurEffectView)
    }
    
    private func combiningScaleAndTranslateTrnsforms() -> Void {
        let scale = CGAffineTransformMakeScale(0.0, 0.0)
        let translate = CGAffineTransformMakeTranslation(0, 500)
        dialogView.transform = CGAffineTransformConcat(scale, translate)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
