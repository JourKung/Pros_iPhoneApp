//
//  PromotionDetailViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/23/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class PromotionDetailViewController: BaseTableViewController {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------

    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var promotionSegue: Promotion!
    var activities: PromotionDetail!
    var imageCache = [String: UIImage]()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        customUI()
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
    
    @IBAction func shareBarButtonItem(sender: AnyObject) {
        performWithShareViewControllerAnimated(true)
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
    }
    
    func customTableView() -> Void {
        tableView.estimatedRowHeight = 360.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    func updateUI() -> Void {
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        if self.prosAPIClient?.getPromotionsWithCompletion() == nil {
            return
        }
        
        refreshControl?.beginRefreshing()
        
        self.prosAPIClient?.getPromotionDetailWithCompletion(UserDefaults.sharedInstance.getUserFbId(), promotionId: self.promotionSegue.promotionID).responseJSON { (request, reponse, results, error) -> Void in
            
            if let promotion: AnyObject = results {
                self.activities = PromotionDetail(promotionID: promotion.objectForKey("promotionID") as String
                        , UserID: promotion.objectForKey("UserID") as String
                        , promotionPublishPoint: promotion.objectForKey("promotionPublishPoint") as String
                        , promotionPublishName: promotion.objectForKey("promotionPublishName") as String
                        , promotionPublishType: promotion.objectForKey("promotionPublishType") as String
                        , promotionPublishDescription: promotion.objectForKey("promotionPublishDescription") as String
                        , promotionPublishPoster: promotion.objectForKey("promotionPublishPoster") as String
                        , qrID: promotion.objectForKey("qrID") as String
                        , promotionPublishCreatedAt: promotion.objectForKey("promotionPublishCreatedAt") as String
                        , promotionPublishUpdatedAt: promotion.objectForKey("promotionPublishUpdatedAt") as String
                        , promotionPublishPublishedAt: promotion.objectForKey("promotionPublishPublishedAt") as String
                        , promotionPublishExpiredAt: promotion.objectForKey("promotionPublishExpiredAt") as String
                        , shopName: promotion.objectForKey("shopName") as String
                        , shopLogoURL: promotion.objectForKey("shopLogoURL") as String
                        , shopType: promotion.objectForKey("shopType") as String)
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func performWithShareViewControllerAnimated(animated: Bool) -> Void {
        var promotionImage: UIImage!
        
        if let imageCache = self.imageCache[self.activities.promotionPublishPoster] {
            promotionImage = imageCache
        } else {
//            promotionImage = UIImage(named: "00_logoDummy")
        }
        
        
        let title: String! = self.activities.shopName
        let type: String! = self.activities?.shopType
        let detail: String! = self.activities?.promotionPublishDescription
        
        let objectsToShare: [AnyObject]! = [promotionImage, title, type, detail]
        
        var activityViewController: UIActivityViewController! = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
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
        presentViewController(activityViewController, animated: animated, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    private let cellIdentifier = "Cell"
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as PromotionDetailTableViewCell
        
        cell.titleLabel.text = self.activities?.shopName
        cell.typeLabel.text = self.activities?.shopType
        cell.descriptionLabel.text = self.activities?.promotionPublishDescription
        
        if let activitiyUserLogoImageUrl = self.activities?.shopLogoURL {
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
                    if let cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath) as? PromotionDetailTableViewCell {
                        cellToUpdate.logoImageView.image = image
                    }
                })
            }
        }
        
        if let activitiyPromotionImageUrl = self.activities?.promotionPublishPoster {
            let tmpURL = Utilities.cleanUrl(activitiyPromotionImageUrl)
            let image = self.imageCache[tmpURL]
            
            if (image == nil) {
                // Download an NSData representation of the image at the URL
                let urlRequest: NSURLRequest! = NSURLRequest(URL: NSURL(string: tmpURL)!)
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    
                    if (connectionError == nil && data != nil) {
                        self.imageCache[tmpURL] = UIImage(data: data)
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath) as? PromotionDetailTableViewCell {
                                cellToUpdate.promotionImageView.image = self.imageCache[tmpURL]
                            }
                        })
                    }
                    else {
                        println("Error: \(connectionError.localizedDescription)")
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    if let cellToUpdate = self.tableView.cellForRowAtIndexPath(indexPath) as? PromotionDetailTableViewCell {
                        cellToUpdate.promotionImageView.image = image
                    }
                })
            }
        }
        
        cell.releasedDate.text = Utilities.dateWithString(NSDate(), dateStype: .ShortStyle, timeStyle: .NoStyle)
        cell.expiredDate.text = Utilities.dateWithString(NSDate(), dateStype: .ShortStyle, timeStyle: .NoStyle)
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
    // ------------------------------
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "Segue") {
            // pass data to next view
        }
    }
    */
}
