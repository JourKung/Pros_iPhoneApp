//
//  NotificationViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader

class NotificationViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var categoryBarButtonItem: UIBarButtonItem!
    
    let prosAPIClient = ProsAPIClient()
    var activities = [Notification]()
    var imageCache = [String: UIImage]()
    
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
    
    @IBAction func menuBarButtonItem(sender: AnyObject) {
        performWithShopCategoryViewControllerAnimated(true)
    }
    
    @IBAction func unwindCloseWithShopCategoryController(segue: UIStoryboardSegue) {
        println("[Unwind] From ShopCategory to Notification")
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
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Notifications")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
    }
    
    func customTableView() -> Void {
        self.tableViewOutlet.estimatedRowHeight = 80.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
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
        let form = NotificationForm()
        form.fbId = UserDefaults.sharedInstance.getUserFbId()
        
        NSOperationQueue().addOperationWithBlock({
            self.prosAPIClient.getNotificationWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                if let notification = Mapper<Notification>().mapArray(results) {
                    self.activities = notification
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableViewOutlet.reloadData()
                    self.tableViewOutlet.stopPullToRefresh()
                })
            }
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func performWithShopCategoryViewControllerAnimated(animated: Bool) -> Void {
        let containerShopCategoryVC = storyboard?.instantiateViewControllerWithIdentifier("ShopCategoryViewController") as! UINavigationController
        presentViewController(containerShopCategoryVC, animated: animated, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NotificationTableViewCell
        
        if let shopName = self.activities[indexPath.row].shopName {
            cell.shopNameLabel.text = shopName
        } else {
            cell.shopNameLabel.text = "nil"
        }
        
        if let shopType = self.activities[indexPath.row].shopType {
            cell.promotionTypeNameLabel.text = shopType
        } else {
            cell.promotionTypeNameLabel.text = "nil"
        }
        
        if let publishedAt = self.activities[indexPath.row].publishedAt {
            cell.promotionPublishedAtLabel.text = ISO8601DateFormatter().dateFromString(publishedAt).timeAgo
        } else {
            cell.promotionPublishedAtLabel.text = "nil"
        }
        
        if let name = self.activities[indexPath.row].name {
            cell.promotionNameLabel.text = name
        } else {
            cell.promotionNameLabel.text = "nil"
        }
                
        let placeholder = UIImage(named: "00_icon_people")!
        if let activitiyShopLogoImageUrl = self.activities[indexPath.row].shopImageURL {
            let URL: NSURL = NSURL(string: activitiyShopLogoImageUrl)!
            cell.shopLogoImageView?.load(URL, placeholder: placeholder)
        } else {
            cell.shopLogoImageView.image = placeholder
        }
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
    // ------------------------------
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableViewOutlet.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToNotificationDetail" {
            println("[Segue] Notification -> Promotion Detail")
            if let indexPath = self.tableViewOutlet.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! PromotionDetailViewController
                destinationController.promotionIdSegue = self.activities[indexPath.row].promotionID
            }
        } else if (segue.identifier == "SegueToShopCategory") {
            println("[Segue] Notification -> Shop category")
        }
    }

}
