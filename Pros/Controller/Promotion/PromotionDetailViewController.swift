//
//  PromotionDetailViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/23/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader
import TTTAttributedLabel
import SVWebViewController

class PromotionDetailViewController: BaseViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    UIScrollViewDelegate,
    CNPPopupControllerDelegate,
    TTTAttributedLabelDelegate,
    PromotionDetailTableViewCellDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var popupController: CNPPopupController!
    var promotionIdSegue: String!
    var activities: PromotionDetail!
    var activitiesLikeState: Bool!
    
    var serialNumberBarButtonItem: UIBarButtonItem!
    var shareBarButtonItem: UIBarButtonItem!
        
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func setupView() -> Void {
        customNavigationBar()
        customTableView()
        customPullToRefresh()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Detail")
        
        self.shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_icon_share"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithShareViewControllerAnimated:")
        self.serialNumberBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_icon_serialNumber"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithSerialNumberViewControllerAnimated:")
        
        self.shareBarButtonItem.enabled = false
        self.serialNumberBarButtonItem.enabled = false
        navigationItem.rightBarButtonItems = [self.shareBarButtonItem, self.serialNumberBarButtonItem]
    }
    
    func customTableView() -> Void {
        self.tableViewOutlet.estimatedRowHeight = 310.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        self.tableViewOutlet.separatorColor = UIColor.clearColor()
    }
    
    func customPullToRefresh() -> Void {
        self.tableViewOutlet.addPullToRefresh({ [weak self] in
            self?.loadData()
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        NSOperationQueue().addOperationWithBlock({
            let form = PromotionDetailForm()
            form.fbId = UserDefaults.sharedInstance.getUserFbId()
            form.promotionId = self.promotionIdSegue
            
            self.prosAPIClient.getPromotionDetailWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                if let promotionDetail = Mapper<PromotionDetail>().map(results) {
                    self.activities = promotionDetail
                    
                    if let activity = self.activities {
                        self.shareBarButtonItem.enabled = true
                        if let qrID = activity.qrID {
                            self.serialNumberBarButtonItem.enabled = true
                        }
                    }
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableViewOutlet.reloadData()
                    self.tableViewOutlet.stopPullToRefresh()
                })
            }
        })
        
        NSOperationQueue().addOperationWithBlock({
            let form = LikeForm()
            form.fbId = UserDefaults.sharedInstance.getUserFbId()
            form.promotionId = self.promotionIdSegue
            
            self.prosAPIClient.getLikeByFbIdAndPromotionIdWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                if let status = results as? Bool {
                    self.activitiesLikeState = status
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableViewOutlet.reloadData()
                })
            }
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func performWithShareViewControllerAnimated(animated: Bool) -> Void {
        if let activity = self.activities {
            if let promotionPoster = activity.poster {
                let URL: NSURL = NSURL(string: promotionPoster)!
                let urlRequest: NSURLRequest! = NSURLRequest(URL: URL)
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    if (connectionError == nil && data != nil) {
                        
                        let by: String! = "@ \(activity.shopName!)"
                        let image: UIImage! = UIImage(data: data)
                        
                        let objectsToShare: [AnyObject]! = [image, by]
                        let activityViewController: UIActivityViewController! = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
                        
                        let excludedActivities = [
                            //UIActivityTypeAirDrop,
                            //UIActivityTypePostToFacebook,
                            //UIActivityTypePostToTwitter,
                            //UIActivityTypeMessage,
                            //UIActivityTypeMail,
                            //UIActivityTypePrint,
                            //UIActivityTypeCopyToPasteboard,
                            UIActivityTypePostToWeibo,
                            UIActivityTypeAssignToContact,
                            UIActivityTypeSaveToCameraRoll,
                            UIActivityTypeAddToReadingList,
                            UIActivityTypePostToFlickr,
                            UIActivityTypePostToVimeo,
                            UIActivityTypePostToTencentWeibo
                        ]
                        
                        activityViewController.excludedActivityTypes = excludedActivities
                        
                        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
                            println("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
                            if (success == true) {
                                self.performWithShareAPI()
                            }
                        }
                        self.presentViewController(activityViewController, animated: animated, completion: nil)
                    } else {
                        println("[Log] Error: \(connectionError.localizedDescription)")
                    }
                })
            }
        }
    }
    
    func performWithSerialNumberViewControllerAnimated(animated: Bool) -> Void {
        if let activity = self.activities {
            if let qrID = activity.qrID {
                showPopupWithStyle(CNPPopupStyle.Centered, qrID: qrID)
            } else {
                showPopupWithStyle(CNPPopupStyle.Centered, qrID: "nil")
            }
        }
    }
    
    func performWithShareAPI() -> Void {
        let form = ShareForm()
        form.fbId = UserDefaults.sharedInstance.getUserFbId()
        form.promotionId = self.promotionIdSegue
        
        self.prosAPIClient.getShareByFbIdAndPromotionIdWithCompletion(form).responseJSON {
            (request, response, results, error) -> Void in
            
            if let status = results as? Bool {
                println("[Log] share state: \(status)")
            }
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PromotionDetailTableViewCell
        
        if let activity = self.activities {
            
            cell.delegate = self
            
            if let shopName = activity.shopName {
                cell.shopNameLabel.text = shopName
            } else {
                cell.shopNameLabel.text = "nil"
            }
            
            if let shopType = activity.shopType {
                cell.shopTypeNameLabel.text = shopType
            } else {
                cell.shopTypeNameLabel.text = "nil"
            }
            
            if let name = activity.name {
                cell.promotionNameLabel.text = name
            } else {
                cell.shopTypeNameLabel.text = "nil"
            }
            
            if let type = activity.type {
                cell.promotionTypeNameLabel.text = type
            } else {
                cell.promotionTypeNameLabel.text = "nil"
            }
            
            if let description = activity.description {
                customTTTAttributedLabel(cell.promotionDescriptionLabel, message: description)
                cell.promotionDescriptionLabel.text = description
            } else {
                cell.promotionDescriptionLabel.text = "nil"
            }
            
            if let publishedAt = activity.publishedAt {
                cell.promotionExpiredDate.text = Utilities.dateWithString(ISO8601DateFormatter().dateFromString(publishedAt), dateStype: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
            } else {
                cell.promotionExpiredDate.text = "nil"
            }
            
            cell.promotionTypeImageView.image = UIImage(named: "00_icon_megaphone-1")
            
            
            let placeholder = UIImage(named: "00_icon_people")!
            if let shopImageURL = activity.shopImageURL {
                let URL: NSURL = NSURL(string: activity.shopImageURL!)!
                cell.shopLogoImageView?.load(URL, placeholder: placeholder)
            } else {
                cell.shopLogoImageView.image = placeholder
            }
            
            if let promotionPoster = self.activities.poster {
                let URL: NSURL = NSURL(string: promotionPoster)!
                cell.promotionImageView?.load(URL)
            }
            
            if let activityLikeState = self.activitiesLikeState {
                if activitiesLikeState.boolValue {
                    cell.like()
                } else {
                    cell.unlike()
                }
            }
        }

        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Promotion detail activity table view cell controller deleagete
    // ------------------------------
    
    func getLikeToggleDelegate(cell: AnyObject) -> Void {
        if let status = self.activitiesLikeState {
            status ? performWithUnlike(cell) : performWithToggleAPI(cell)
        }
    }
    
    func performWithUnlike(cell: AnyObject) -> Void {
        let alertController = UIAlertController(title: "Do you want to unlike this?", message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("[Log] Cancel ActionSheet")
        }
        alertController.addAction(cancelAction)
        
        let unlikeAction = UIAlertAction(title: "Unlike", style: .Destructive) { (action) in
            self.performWithToggleAPI(cell)
            cell.unlike()
        }
        alertController.addAction(unlikeAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func performWithToggleAPI(cell: AnyObject) -> Void {
        let form = PromotionLikeToggleForm()
        form.fbId = UserDefaults.sharedInstance.getUserFbId()
        form.promotionId = self.promotionIdSegue
        
        self.prosAPIClient.getLikeToggleByFbIdAndPromotionIdWithCompletion(form).responseJSON {
            (request, response, results, error) -> Void in
            
            if let status = results as? Bool {
                println("[Log] like state: \(status)")
                self.activitiesLikeState = status
                self.tableViewOutlet.reloadData()
            }
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: CNPPopupController delegate
    // ------------------------------
    
    func popupController(controller: CNPPopupController!, didDismissWithButtonTitle title: String!) {
        println("[Log] Dismissed with button title: \(title)")
    }
    
    func popupControllerDidPresent(controller: CNPPopupController!) {
        println("[Log] Popup controller presented.")
    }
    
    func showPopupWithStyle(popupStyle: CNPPopupStyle!, qrID: String!) {
        var paragraphStyle: NSMutableParagraphStyle! = NSMutableParagraphStyle.new()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let icon: UIImage! = UIImage(named: "00_qrDummy")
        let title: NSAttributedString! = NSAttributedString(string: "Promotion code",
            attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(24),
            NSParagraphStyleAttributeName: paragraphStyle])
        let lineOne: NSAttributedString! = NSAttributedString(string: qrID,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18),
                NSForegroundColorAttributeName: UIColor(red: 0.46, green: 0.8, blue: 1.0, alpha: 1.0),
                NSParagraphStyleAttributeName: paragraphStyle])
        let lineTwo: NSAttributedString! = NSAttributedString(string: "Show this code to the store",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18),
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: paragraphStyle])
        
        let buttonTitle: NSAttributedString! = NSAttributedString(string: "Close me",
            attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSParagraphStyleAttributeName: paragraphStyle])
        
        let buttonItem: CNPPopupButtonItem! = CNPPopupButtonItem.defaultButtonItemWithTitle(buttonTitle, backgroundColor: UIColor(red: 0.46, green: 0.8, blue: 1.0, alpha: 1.0))
        buttonItem.selectionHandler = { (item: CNPPopupButtonItem!) -> Void in
            println("[Log] Block for button: \(item.buttonTitle.string)")
        }
        
        self.popupController = CNPPopupController(title: title, contents: [lineOne, icon, lineTwo], buttonItems: [buttonItem], destructiveButtonItem: nil)
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.theme.presentationStyle = CNPPopupPresentationStyle.SlideInFromBottom
        self.popupController.presentPopupControllerAnimated(true)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: TTTAttributedLabel delegate
    // ------------------------------
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let modalWebViewController: SVModalWebViewController! = SVModalWebViewController(URL: url)
        presentViewController(modalWebViewController, animated: true, completion: nil)
    }
    
    func customTTTAttributedLabel(label: TTTAttributedLabel!, message: String!) -> Void {
        label.delegate = self
        label.enabledTextCheckingTypes = NSTextCheckingType.Link.rawValue
        label.backgroundColor = UIColor.clearColor()
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
    }
}
