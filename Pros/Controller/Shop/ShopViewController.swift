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
    FeedbackViewControllerDelegate,
    ShopActivityTableViewCellDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
//    var shopActivityTableViewCell: ShopActivityTableViewCell! = ShopActivityTableViewCell()
    var feedbackVC: FeedbackViewController!
    
    @IBOutlet weak var rightBarButtonItem: UIBarButtonItem!
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var subShopCategorySegue: SubShopCategory!
    var activities: Shop!
    var activitiesSubscribeStatus: Bool!
    
    var imageCache = [String: UIImage]()
    
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
//        self.shopActivityTableViewCell.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
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
    
    func customUI() -> Void {
        customNavigationBar()
        customTableView()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Detail")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()

        // action: Selector("funcName") or "funcName" Note: funcName isn't private func
        let feedbackBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_more-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithFeedbackViewControllerAnimated:")
        let shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "01_share-toolbar"), style: UIBarButtonItemStyle.Plain, target: self, action: "performWithShareViewControllerAnimated:")
        navigationItem.rightBarButtonItems = [shareBarButtonItem, feedbackBarButtonItem]
    }
    
    func customTableView() -> Void {
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
    
    func customParallaxHeaderTableView() -> Void {
        // Set the contentInset to make room for the image.
        tableView.contentInset = UIEdgeInsets(top: self.imageHeight, left: 0, bottom: 0, right: 0)
        
        if let activitiyUserCoverImageUrl = self.activities?.UserCoverImageUrl {
            let tmpURL = Utilities.cleanUrl(activitiyUserCoverImageUrl)
            let image = self.imageCache[tmpURL]
            
            if (image == nil) {
                // Download an NSData representation of the image at the URL
                let urlRequest: NSURLRequest! = NSURLRequest(URL: NSURL(string: tmpURL)!)
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    
                    if (connectionError == nil && data != nil) {
                        self.imageCache[tmpURL] = UIImage(data: data)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            self.imageView.image = self.imageCache[tmpURL]
                        })
                    }
                    else {
                        println("Error: \(connectionError.localizedDescription)")
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = image
                })
            }
        } else {
            self.imageView.image = UIImage(named: "00_coverDummy")
        }
    
        
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
    
    func loadData() -> Void {
        if self.prosAPIClient?.getCategoriesWithCompletion() == nil {
            return
        }
        
        refreshControl?.beginRefreshing()
        
        self.prosAPIClient?.getShopByShopIdWithCompletion(self.subShopCategorySegue.shopId).responseJSON { (request, reponse, results, error) -> Void in
            
            if let shop = results as? [String: AnyObject] {
                self.activities = Shop(shopId: shop["id"] as! String
                    , name: shop["name"] as! String
                    , UserFirstName: shop["UserFirstName"] as! String
                    , UserLastName: shop["UserLastName"] as! String
                    , email: shop["email"] as! String
                    , Username: shop["Username"] as! String
                    , shopType: shop["shopType"] as! String
                    , UserTermCondition: shop["UserTermCondition"] as! String
                    , UserLogoImageUrl: shop["UserLogoImageUrl"] as! String
                    , UserCoverImageUrl: shop["UserCoverImageUrl"] as! String
                    , UserShopDescription: shop["UserShopDescription"] as! String
                    , UserLocationLat: shop["UserLocationLat"] as! String
                    , UserLocationLong: shop["UserLocationLong"] as! String
                    , Telephone: shop["Telephone"] as! String
                    , ShopConcept: shop["ShopConcept"] as! String
                    , created_at: shop["created_at"] as! String
                    , updated_at: shop["updated_at"] as! String)
                
                self.customParallaxHeaderTableView()
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
        
        self.prosAPIClient?.getSubscribeByFbIdAndShopIdWithCompletion(UserDefaults.sharedInstance.getUserFbId(), shopId: self.subShopCategorySegue?.shopId).responseJSON {
            (request, reponse, results, error) -> Void in
            
            if let status = results as? Bool {
                self.activitiesSubscribeStatus = status
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    private let activityCellIdentifier      = "ActivityCell"
    private let descriptionCellIdentifier   = "DescriptionCell"
    private let locationCellIdentifier      = "LocationCell"
    private let supportCellIdentifier       = "SupportCell"
    
    func activitiyTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(activityCellIdentifier, forIndexPath: indexPath) as! ShopActivityTableViewCell
        cell.titleLabel.text = self.activities?.name
        cell.typeLabel.text = self.activities?.shopType
        cell.delegate = self
        
        if let subscribeStatus = self.activitiesSubscribeStatus?.boolValue {
            if subscribeStatus {
                cell.subscribe()
            } else {
                cell.unsubscribe()
            }
        }
        
        if let activitiyUserLogoImageUrl = self.activities?.UserLogoImageUrl {
            let tmpURL = Utilities.cleanUrl(activitiyUserLogoImageUrl)
            let image = self.imageCache[tmpURL]
            
            if (image == nil) {
                // Download an NSData representation of the image at the URL
                let urlRequest: NSURLRequest! = NSURLRequest(URL: NSURL(string: tmpURL)!)
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    
                    if (connectionError == nil && data != nil) {
                        self.imageCache[tmpURL] = UIImage(data: data)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath) as? ShopActivityTableViewCell {
                                cellToUpdate.logoImageView.image = self.imageCache[tmpURL]
                            }
                        })
                    }
                    else {
                        println("Error: \(connectionError.localizedDescription)")
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath) as? ShopActivityTableViewCell {
                        cellToUpdate.logoImageView.image = image
                    }
                })
            }
        }
        
        
        
        return cell
    }
    
    func descriptionTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(descriptionCellIdentifier, forIndexPath: indexPath) as! ShopDescriptionTableViewCell
        cell.descriptionLabel.text = self.activities?.UserShopDescription
        
        return cell
    }
    
    func locationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(locationCellIdentifier, forIndexPath: indexPath) as! ShopLocationTableViewCell
        cell.locationLabel.text = "Cupertino, CA 95014 (408) 996-1010"
        
        return cell
    }
    
    func supportTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(supportCellIdentifier, forIndexPath: indexPath) as! ShopSupportTableViewCell
        
        return cell
    }
    
    func performWithFeedbackViewControllerAnimated(animated: Bool) -> Void {
        let containerFeedbackVC = storyboard?.instantiateViewControllerWithIdentifier("FeedbackViewController") as! FeedbackViewController
        // userId, shopId, coverImage Aspect Fill (Background blurEffect), logoImage
        containerFeedbackVC.logoImage = UIImage(named: "00_logoDummy")
        containerFeedbackVC.delegate = self
        presentViewController(containerFeedbackVC, animated: animated, completion: nil)
    }
    
    func performWithLocationViewControllerAnimated(animated: Bool) -> Void {
        let containerLocationVC = storyboard?.instantiateViewControllerWithIdentifier("LocationViewController") as! UINavigationController//LocationViewController
//        presentViewController(containerLocationVC, animated: animated, completion: nil)
        navigationController?.presentViewController(containerLocationVC, animated: animated, completion: nil)
    }
    
    func performWithShareViewControllerAnimated(animated: Bool) -> Void {
        var logoImage: UIImage!
        
        if let imageCache = self.imageCache[self.activities.UserLogoImageUrl] {
            logoImage = imageCache
        } else {
            logoImage = UIImage(named: "00_logoDummy")
        }
        
        let title: String! = self.activities?.name
        let type: String! = self.activities?.shopType
        let detail: String! = self.activities?.UserShopDescription
        
        let objectsToShare: [AnyObject]! = [logoImage, title, type, detail]
        
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
    
    // ------------------------------
    // MARK: -
    // MARK: Shop activity table view cell controller deleagete
    // ------------------------------
    
    func getToggleDelegate() -> Void {
        self.prosAPIClient?.getToggleSubscribeByFbIdAndShopIdWithCompletion(UserDefaults.sharedInstance.getUserFbId(), shopId: self.subShopCategorySegue?.shopId).responseJSON {
            (request, reponse, results, error) -> Void in
            
            if let status = results as? Bool {
                self.activitiesSubscribeStatus = status
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
}
