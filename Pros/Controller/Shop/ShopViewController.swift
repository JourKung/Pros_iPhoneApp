//
//  ShopViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader
import Alamofire

class ShopViewController: BaseTableViewController,
    UIScrollViewDelegate,
    FeedbackViewControllerDelegate,
    ShopActivityTableViewCellDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var activities: Shop!
    var activitiesFeedback: [Feedback]!
    var activitiesSubscribeState: Bool!
    var subShopCategorySegue: SubShopCategory!
    
    var feedbackBarButtonItem: UIBarButtonItem!
    var shareBarButtonItem: UIBarButtonItem!
    
    // Create the UIImageView
    let imageView = UIImageView()
    // Set the factor for the parallaxEffect. This is overwritable.
    var parallaxFactor: CGFloat = 2
    // Set the default height for the image on the top.
    var imageHeight: CGFloat = 300 {
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
        
        loadData()
        setupView()
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
    
    func setupView() -> Void {
        customNavigationBar()
        customTableView()
        customPullToRefresh()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Detail")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()

        // action: Selector("funcName") or "funcName" Note: funcName isn't private func
        self.feedbackBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_more-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithFeedbackViewControllerAnimated:")
        self.shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_icon_share"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithShareViewControllerAnimated:")
        self.feedbackBarButtonItem.enabled = false
        self.shareBarButtonItem.enabled = false
        navigationItem.rightBarButtonItems = [self.shareBarButtonItem, self.feedbackBarButtonItem]
    }
    
//    func updateUI() -> Void {
//        self.feedbackBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_more-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithFeedbackViewControllerAnimated:")
//        navigationItem.rightBarButtonItems?.insert(self.feedbackBarButtonItem, atIndex: 1)
//    }
    
    func customTableView() -> Void {
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
//        tableView.tableFooterView = UIView(frame: CGRectZero)
//        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
//        let headerView = ParallaxHeaderView.parallaxHeaderViewWithImage(UIImage(named: "00_coverDummy"), forSize: CGSizeMake(tableView.frame.size.width, 200)) as! ParallaxHeaderView
//        headerView.headerTitleLabel.text = "Starbucks Coffee"
//        headerView.headerLogoImageView.image = UIImage(named: "00_logoDummy")
//        tableView.tableHeaderView = headerView
    }
    
    func customPullToRefresh() -> Void {
        refreshControl!.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
    }
    
    func customParallaxHeaderTableView() -> Void {
        // Set the contentInset to make room for the image.
        tableView.contentInset = UIEdgeInsets(top: self.imageHeight, left: 0, bottom: 0, right: 0)
        
        if let activitiyUserCoverImageUrl = self.activities?.coverImageURL {
            let URL: NSURL = NSURL(string: activitiyUserCoverImageUrl)!
            self.imageView.load(URL)
        } else {
            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            var blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            self.imageView.addSubview(blurEffectView)
        }
        
        // Change the contentMode for the ImageView.
        self.imageView.contentMode = .ScaleAspectFill
        // Add the imageView to the TableView and send it to the back.
        view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        refreshControl?.beginRefreshing()
        
        NSOperationQueue().addOperationWithBlock({
            let form = ShopForm()
            form.shopId = self.subShopCategorySegue.shopID
            self.prosAPIClient.getShopByShopIdWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                if let shop = Mapper<Shop>().map(results) {
                    self.activities = shop
                    self.customParallaxHeaderTableView()
                    
                    self.shareBarButtonItem.enabled = true
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                    self.refreshControl?.endRefreshing()
                })
            }
        })
                
        NSOperationQueue().addOperationWithBlock({
            let form = SubscribeForm()
            form.fbId = UserDefaults.sharedInstance.getUserFbId()
            form.shopId = self.subShopCategorySegue.shopID
            self.prosAPIClient.getSubscribeByFbIdAndShopIdWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                if let status = results as? Bool {
                    self.activitiesSubscribeState = status
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableView.reloadData()
                })
            }
        })
        
        NSOperationQueue().addOperationWithBlock({
            let form = FeedbackForm()
            form.shopId = self.subShopCategorySegue?.shopID
            self.prosAPIClient.getFeedbackWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                if let feedback = Mapper<Feedback>().mapArray(results) {
                    if feedback.count == 0 {
                        self.feedbackBarButtonItem.enabled = false
                    } else {
                        self.activitiesFeedback = feedback
                        self.feedbackBarButtonItem.enabled = true
                    }
                }
            }
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func activitiyTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "ActivityCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopActivityTableViewCell
        
        if let activity = self.activities {
            
            cell.delegate = self
            
            if let name = activity.name {
                cell.shopNameLabel.text = name
            } else {
                cell.shopNameLabel.text = "nil"
            }
            
            if let shopType = activity.shopType {
                cell.shopTypeNameLabel.text = shopType
            } else {
                cell.shopTypeNameLabel.text = "nil"
            }
            
            let placeholder = UIImage(named: "00_icon_people")!
            if let logoImageURL = activity.logoImageURL {
                let URL: NSURL! = NSURL(string: logoImageURL)
                cell.shopLogoImageView?.load(URL, placeholder: placeholder)
            } else {
                cell.shopLogoImageView.image = placeholder
            }
        }

        if let activitySubscribeState = self.activitiesSubscribeState {
            if activitiesSubscribeState.boolValue {
                cell.subscribe()
            } else {
                cell.unsubscribe()
            }
        }
       
        return cell
    }
    
    func descriptionTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "DescriptionCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopDescriptionTableViewCell
        cell.shopDescriptionLabel.text = self.activities?.description
        
        return cell
    }
    
    func locationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "LocationCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopLocationTableViewCell
        cell.shopLocationLabel.text = self.activities?.address
        
        return cell
    }
    
    func supportTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "SupportCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopSupportTableViewCell
        
        return cell
    }
    
    func performWithFeedbackViewControllerAnimated(animated: Bool) -> Void {
        let containerFeedbackVC = storyboard?.instantiateViewControllerWithIdentifier("FeedbackViewController") as! FeedbackViewController
        containerFeedbackVC.delegate = self
        
        if let activity = self.activities {
            if let logoImageURL = self.activities?.logoImageURL {
                let URL: NSURL! = NSURL(string: logoImageURL)
                let urlRequest: NSURLRequest! = NSURLRequest(URL: URL)
                
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    if (connectionError == nil && data != nil) {
                        containerFeedbackVC.logoImageView.image = UIImage(data: data)
                    } else {
                        println("[Log] Error: \(connectionError.localizedDescription)")
                    }
                })
            } else {
                containerFeedbackVC.logoImageView.image = UIImage(named: "00_icon_people")
            }
        }
        
        if let question = self.activitiesFeedback.last?.question {
            containerFeedbackVC.questionString = question
        } else {
            containerFeedbackVC.questionString = "How was your experience?"
        }
        
        presentViewController(containerFeedbackVC, animated: animated, completion: nil)
    }
    
    func performWithLocationViewControllerAnimated(animated: Bool) -> Void {
        let containerLocationVC = storyboard?.instantiateViewControllerWithIdentifier("LocationViewController") as! LocationViewController
        if let activity = self.activities {
            containerLocationVC.activities = activity
            
            if let logoImageURL = activity.logoImageURL {
                let URL: NSURL! = NSURL(string: logoImageURL)
                let urlRequest: NSURLRequest! = NSURLRequest(URL: URL)
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    if (connectionError == nil && data != nil) {
                        containerLocationVC.logoImageCache = UIImage(data: data)
                    } else {
                        println("[Log] Error: \(connectionError.localizedDescription)")
                    }
                })
            } else {
                containerLocationVC.logoImageCache = UIImage(named: "00_icon_people")
            }
            
            presentViewController(containerLocationVC, animated: animated, completion: nil)
        }
    }
    
    func performWithShareViewControllerAnimated(animated: Bool) -> Void {
        if let activity = self.activities {
            if let logoImageURL = self.activities.logoImageURL {
                let URL: NSURL = NSURL(string: logoImageURL)!
                let urlRequest: NSURLRequest! = NSURLRequest(URL: URL)
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    if (connectionError == nil && data != nil) {
                        
                        let by: String! = "@ \(activity.name!)"
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
                        self.presentViewController(activityViewController, animated: animated, completion: nil)
                    } else {
                        println("[Log] Error: \(connectionError.localizedDescription)")
                    }
                })
            }
        }
    }
    
    // Define method for image location changes.
    func moveImage() {
        let imageOffset = (self.scrollOffset >= 0) ? self.scrollOffset / parallaxFactor : 0
        let imageHeight = (self.scrollOffset >= 0) ? self.imageHeight : self.imageHeight - self.scrollOffset
        self.imageView.frame = CGRect(x: 0, y: -imageHeight + imageOffset, width: view.bounds.width, height: imageHeight)
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
        self.scrollOffset = tableView.contentOffset.y + self.imageHeight
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
    
    // ------------------------------
    // MARK: -
    // MARK: Feedback view controller deleagete
    // ------------------------------
    
    func feedbackWithAlertController(message: String!, rating: String!) -> Void {
        let form = LoginWithFacebookForm()
        let alertController = UIAlertController(title: "Thank you for submitted", message: "", preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Done", style: .Default, handler: nil)
        alertController.addAction(confirmAction)
        presentViewController(alertController, animated: true, completion: {
            self.submitFeedbackWithForm(rating)
        })
    }
    
    func submitFeedbackWithForm(rating: String!) -> Void {
        let form = SubmitFeedbackForm()
        if let activityFeedback = self.activitiesFeedback.last {
            form.facebook_id = UserDefaults.sharedInstance.getUserFbId()
            form.feedbackquestion_id = activityFeedback.feedbackID
            form.answer = rating
            
            NSOperationQueue().addOperationWithBlock({
                self.prosAPIClient.postSubmitFeedbackWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                    if let result = results as? Bool {
                        println("[Submit feedback] \(form.facebook_id) | \(form.feedbackquestion_id) | \(result)")
                    }
                }
            })
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Shop activity table view cell controller deleagete
    // ------------------------------
    
    func getSubscribeStateToggleDelegate(cell: AnyObject) -> Void {
        if let status = self.activitiesSubscribeState {
            // status ? Subscribed : Not subscribe
            status ? (performWithUnsubscribe(cell)) : (performWithToggleAPI())
        }
    }
    
    func performWithUnsubscribe(cell: AnyObject) -> Void {
        let alertController = UIAlertController(title: self.activities?.name, message: nil, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("[Log] Cancel ActionSheet")
        }
        alertController.addAction(cancelAction)
        
        let unsubscribeAction = UIAlertAction(title: "Unsubscribe", style: .Destructive) { (action) in
            self.performWithToggleAPI()
            cell.unsubscribe()
        }
        alertController.addAction(unsubscribeAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func performWithToggleAPI() -> Void {
        let form = ShopSubscribeToggleForm()
        form.fbId = UserDefaults.sharedInstance.getUserFbId()
        form.shopId = subShopCategorySegue.shopID
        
        self.prosAPIClient.getSubscribeToggleByFbIdAndShopIdWithCompletion(form).responseJSON {
            (request, response, results, error) -> Void in
            
            if let status = results as? Bool {
                println("[Log] subscribe state: \(status)")
                self.activitiesSubscribeState = status
                self.tableView.reloadData()
            }
        }
    }
}
