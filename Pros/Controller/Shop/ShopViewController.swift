//
//  ShopViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class ShopViewController: BaseTableViewController,
    UIScrollViewDelegate,
    FeedbackViewControllerDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    // Create the UIImageView
    let imageView = UIImageView()
    // Set the factor for the parallaxEffect. This is overwritable.
    var parallaxFactor: CGFloat = 2
    // Set the default height for the image on the top.
    var imageHeight: CGFloat = 200 {
        didSet {
            moveImage()
        }
    }
    // Initialize the scrollOffset varaible.
    var scrollOffset: CGFloat = 0 {
        didSet {
            moveImage()
        }
    }
    
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
//        (self.tableViewOutlet.tableHeaderView as ParallaxHeaderView).refreshBlurViewForNewImage()
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        // Update the image position after layout changes.
        moveImage()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    /*
    @IBAction func rightBarButtonItem(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("[Log] Cancel ActionSheet")
        }
        alertController.addAction(cancelAction)
        
        let feedbackAction = UIAlertAction(title: "Feedback", style: .Default) { (action) in
            self.performWithFeedbackViewControllerAnimated(true)
        }
        alertController.addAction(feedbackAction)
        
        let shareAction = UIAlertAction(title: "Share", style: .Default) { (action) in
            self.performWithShareViewControllerAnimated(true)
        }
        alertController.addAction(shareAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    */
    @IBAction func unwindCloseWithFeedbackViewController(segue: UIStoryboardSegue) {
        println("[Unwind] From Feedback to Shop")
    }
    
    @IBAction func unwindCloseWithLocationViewController(segue: UIStoryboardSegue) {
        println("[Unwind] From Location to Shop")
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customUI() -> Void {
        customNavigationBar()
        customTableView()
        customParallaxHeaderTableView()
    }
    
    private func customNavigationBar() -> Void {
//        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Detail")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()

        // action: Selector("funcName") or "funcName" Note: funcName isn't private func
        let feedbackBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_more-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithFeedbackViewControllerAnimated:")
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "01_share-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithShareViewControllerAnimated:")
        navigationItem.rightBarButtonItems = [shareBarButtonItem, feedbackBarButtonItem]
    }
    
    private func customTableView() -> Void {
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
//        let headerView: ParallaxHeaderView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "00_coverDummy"), forSize: CGSizeMake(self.tableViewOutlet.frame.size.width, 200)) as ParallaxHeaderView
//        headerView.headerTitleLabel.text = "Starbucks Coffee"
//        headerView.headerLogoImageView.image = UIImage(named: "00_logoDummy")
//        self.tableViewOutlet.tableHeaderView = headerView
    }
    
    private func customParallaxHeaderTableView() -> Void {
        // Set the contentInset to make room for the image.
        tableView.contentInset = UIEdgeInsets(top: self.imageHeight, left: 0, bottom: 0, right: 0)
        self.imageView.image = UIImage(named: "00_coverDummy")
        // Change the contentMode for the ImageView.
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        // Add the imageView to the TableView and send it to the back.
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
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
        let cell = tableView.dequeueReusableCellWithIdentifier(activityCellIdentifier, forIndexPath: indexPath) as ShopActivityTableViewCell
        cell.titleLabel.text = "Starbucks Coffee"
        cell.typeLabel.text = "@Cafe"
        cell.logoImageView.image = UIImage(named: "00_logoDummy")
        
        return cell
    }
    
    private func descriptionTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as ShopDescriptionTableViewCell
        cell.descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
        
        return cell
    }
    
    private func locationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(locationCellIdentifier, forIndexPath: indexPath) as ShopLocationTableViewCell
        cell.locationLabel.text = "Cupertino, CA 95014 (408) 996-1010"
        
        return cell
    }
    
    private func supportTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(supportCellIdentifier, forIndexPath: indexPath) as ShopSupportTableViewCell
        
        return cell
    }
    
    func performWithFeedbackViewControllerAnimated(animated: Bool) -> Void {
        let containerFeedbackVC = storyboard?.instantiateViewControllerWithIdentifier("FeedbackViewController") as FeedbackViewController
        // userId, shopId, coverImage Aspect Fill (Background blurEffect), logoImage
        containerFeedbackVC.logoImage = UIImage(named: "00_logoDummy")
        presentViewController(containerFeedbackVC, animated: animated, completion: nil)
    }
    
    func performWithLocationViewControllerAnimated(animated: Bool) -> Void {
        let containerLocationVC = storyboard?.instantiateViewControllerWithIdentifier("LocationViewController") as UINavigationController//LocationViewController
//        presentViewController(containerLocationVC, animated: animated, completion: nil)
        navigationController?.presentViewController(containerLocationVC, animated: animated, completion: nil)
    }
    
    func performWithShareViewControllerAnimated(animated: Bool) -> Void {
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
    
    // Define method for image location changes.
    func moveImage() {
        let imageOffset = (scrollOffset >= 0) ? scrollOffset / parallaxFactor : 0
        let imageHeight = (scrollOffset >= 0) ? self.imageHeight : self.imageHeight - scrollOffset
        imageView.frame = CGRect(x: 0, y: -imageHeight + imageOffset, width: view.bounds.width, height: imageHeight)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Scroll view delegate
    // ------------------------------
    /*
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        let header: ParallaxHeaderView = self.tableViewOutlet.tableHeaderView as ParallaxHeaderView
//        header.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
//        self.tableViewOutlet.tableHeaderView = header
        
        if (scrollView == self.tableViewOutlet) {
            // pass the current offset of the UITableView so that the ParallaxHeaderView layouts the subViews.
            (self.tableViewOutlet.tableHeaderView as ParallaxHeaderView).layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
        }
    }*/
    
    // Update scrollOffset on tableview scroll
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollOffset = tableView.contentOffset.y + imageHeight
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.row) {
        case 2:
            performWithLocationViewControllerAnimated(true)
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
    
    // ------------------------------
    // MARK: -
    // MARK: Feedback view controller deleagete
    // ------------------------------
    
    func feedbackWithAlertController(message: String!) {
        let alertController = UIAlertController(title: message, message: "", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Done", style: .Default, handler: nil)
        alertController.addAction(confirmAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
