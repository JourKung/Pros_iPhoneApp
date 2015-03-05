//
//  ShopViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class ShopViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    UIScrollViewDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
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
        (self.tableViewOutlet.tableHeaderView as ParallaxHeaderView).refreshBlurViewForNewImage()
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func rightBarButtonItem(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("[Log] Cancel ActionSheet")
        }
        alertController.addAction(cancelAction)
        
        let feedbackAction = UIAlertAction(title: "Feedback", style: .Default) { (action) in
            self.performFeedbackViewControllerAnimated(true)
        }
        alertController.addAction(feedbackAction)
        
        let shareAction = UIAlertAction(title: "Share", style: .Default) { (action) in
            self.performShareViewControllerAnimated(true)
        }
        alertController.addAction(shareAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func unwindCloseWithFeedbackViewController(segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindCloseWithLocationViewController(segue: UIStoryboardSegue) {
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customUI() -> Void {
        customNavigationBar()
        
        self.tableViewOutlet.estimatedRowHeight = 80.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
//        self.tableViewOutlet.tableFooterView = UIView(frame:CGRectZero)
//        self.tableViewOutlet.backgroundColor = UIColor.whiteColor()
        self.tableViewOutlet.separatorStyle = UITableViewCellSeparatorStyle.None
        
        let headerView: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "00_coverDummy"), forSize: CGSizeMake(self.tableViewOutlet.frame.size.width, 200)) as ParallaxHeaderView
//        headerView.headerTitleLabel.text = "Starbucks Coffee"
//        headerView.headerLogoImageView.image = UIImage(named: "00_logoDummy")
        self.tableViewOutlet.tableHeaderView = headerView
    }
    
    private func customNavigationBar() -> Void {
//        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Detail")
        
        // action: Selector("funcName") or "funcName" Note: funcName isn't private func
        let feedbackBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_more-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performFeedbackViewControllerAnimated:")
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_share-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performShareViewControllerAnimated:")
        navigationItem.rightBarButtonItems = [shareBarButtonItem, feedbackBarButtonItem]
    }
    
    private func updateUI() -> Void {
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
    
    private let activityCellIdentifier      = "ActivityCell"
    private let descriptionCellIdentifier   = "DescriptionCell"
    private let locationCellIdentifier      = "LocationCell"
    private let supportCellIdentifier       = "SupportCell"
    
    private func activitiyTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(activityCellIdentifier, forIndexPath: indexPath) as ShopActivityTableViewCell
        cell.titleLabel.text = "Starbucks Coffee"
        cell.typeLabel.text = "@Cafe"
        cell.logoImageView.image = UIImage(named: "00_logoDummy")
        
        return cell
    }
    
    private func descriptionTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as ShopDescriptionTableViewCell
        cell.detail.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
        
        return cell
    }
    
    private func locationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(locationCellIdentifier, forIndexPath: indexPath) as ShopLocationTableViewCell
        cell.locationLabel.text = "Cupertino, CA 95014 (408) 996-1010"
        
        return cell
    }
    
    private func supportTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(supportCellIdentifier, forIndexPath: indexPath) as ShopSupportTableViewCell
        
        return cell
    }
    
    func performFeedbackViewControllerAnimated(animated: Bool) -> Void {
        let containerFeedbackVC = storyboard?.instantiateViewControllerWithIdentifier("FeedbackViewController") as FeedbackViewController
        // userId, shopId, coverImage Aspect Fill (Background blurEffect), logoImage
        containerFeedbackVC.logoImage = UIImage(named: "00_logoDummy")
        presentViewController(containerFeedbackVC, animated: animated, completion: nil)
    }
    
    private func performLocationViewControllerAnimated(animated: Bool) -> Void {
        let containerLocationVC = storyboard?.instantiateViewControllerWithIdentifier("LocationViewController") as LocationViewController
        presentViewController(containerLocationVC, animated: animated, completion: nil)
    }
    
    func performShareViewControllerAnimated(animated: Bool) -> Void {
        let logoImage: UIImage! = UIImage(named: "00_logoDummy")
        let coverImage: UIImage! = UIImage(named: "00_coverDummy")
        let title: String! = "Starbucks"
        let type: String! = "@Cafe"
        let detail: String! = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        
        let objectsToShare: [AnyObject]! = [logoImage, coverImage, title, type, detail]
        
        var activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        let excludedActivities = [
            //UIActivityTypeAirDrop
            //UIActivityTypePostToFacebook,
            //UIActivityTypePostToTwitter,
            UIActivityTypePostToWeibo,
            //UIActivityTypeMessage,
            //UIActivityTypeMail,
            //UIActivityTypePrint,
            //UIActivityTypeCopyToPasteboard,
            //UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo]
        
        activityViewController.excludedActivityTypes = excludedActivities
        presentViewController(activityViewController, animated: animated, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Scroll view delegate
    // ------------------------------
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let header: ParallaxHeaderView = self.tableViewOutlet.tableHeaderView as ParallaxHeaderView
//        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
//        self.tableViewOutlet.tableHeaderView = header
        
        if (scrollView == self.tableViewOutlet) {
            // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
            (self.tableViewOutlet.tableHeaderView as ParallaxHeaderView).layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
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
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            return activitiyTableViewCell(indexPath)
        case 1:
            return descriptionTableViewCell(indexPath)
        case 2:
            return locationTableViewCell(indexPath)
        case 3:
            //(support.isValid) ? supportTableViewCell(indexPath) : return
            return supportTableViewCell(indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
    // ------------------------------

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 2:
            performLocationViewControllerAnimated(true)
        default:
            break
        }
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
