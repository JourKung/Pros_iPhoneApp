//
//  PromotionViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader

enum ESTScanType: Int {
    case ESTScanTypeBluetooth
    case ESTScanTypeBeacon
}

enum promotionType: Int {
    case Announcement
    case Discount
    case Campaign
    case MemberCard
}

class PromotionViewController: BaseViewController,
    ESTBeaconManagerDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIScrollViewDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var categoryBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var enterRegionSwitch: UISwitch!
    @IBOutlet weak var exitRegionSwitch: UISwitch!
    
    let prosAPIClient = ProsAPIClient()
    var activities = [Promotion]()
    var activitiesLikeState: Bool!
    
    var beacon: ESTBeacon!
    var beaconManager: ESTBeaconManager!
    var beaconRegion: ESTBeaconRegion!
    var scanType: ESTScanType!
    
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
        println("[Unwind] From ShopCategory to Promotion")
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func setupView() -> Void {
        registerForLocationNotification()
        setupEstimoteBeacons()
                
        customNavigationBar()
        customTableView()
        customPullToRefresh()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Pros")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
    }
    
    func customTableView() -> Void {
        self.tableViewOutlet.estimatedRowHeight = 320.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        self.tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        self.tableViewOutlet.separatorColor = UIColor.clearColor()
        self.tableViewOutlet.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
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
            self.prosAPIClient.getPromotionWithCompletion().responseJSON { (request, response, results, error) -> Void in
                if let promotion = Mapper<Promotion>().mapArray(results) {
                    self.activities = promotion
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
    
    func customCellShopTypeButton(cellShopButton: UIButton) -> Void {
        cellShopButton.addBorder(UIButtonBorderSide.Right, color: UIColor.applicationTwitterLogoBlueColor(), width: 2)
        
        cellShopButton.layer.masksToBounds = false
        cellShopButton.layer.cornerRadius = 1
        cellShopButton.layer.shadowOffset = CGSizeMake(-0.2, 0.2)
        cellShopButton.layer.shadowRadius = 1
        cellShopButton.layer.shadowOpacity = 0.2
        
        let path: UIBezierPath! = UIBezierPath(rect: cellShopButton.bounds)
        cellShopButton.layer.shadowPath = path.CGPath
        cellShopButton.backgroundColor = UIColor.whiteColor()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Scroll view delegate
    // ------------------------------
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableViewOutlet.fixedPullToRefreshViewForDidScroll()
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
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! PromotionTableViewCell
        
        if let shopName = self.activities[indexPath.row].shopName {
            cell.shopNameLabel.text = shopName
        } else {
            cell.shopNameLabel.text = "nil"
        }
        
        if let name = self.activities[indexPath.row].name {
            cell.promotionNameLabel.text = name
        } else {
            cell.promotionNameLabel.text = "nil"
        }
        
        if let type = self.activities[indexPath.row].type {
            cell.promotionTypeNameLabel.text = type
        } else {
            cell.promotionTypeNameLabel.text = "nil"
        }
        
        if let publishedAt = self.activities[indexPath.row].publishedAt {
            cell.promotionPublishedAtLabel.text = ISO8601DateFormatter().dateFromString(publishedAt).timeAgo
        } else {
            cell.promotionPublishedAtLabel.text = "nil"
        }
        
        if let shopType = self.activities[indexPath.row].shopType {
            cell.shopTypeNameButton.setTitle("#\(shopType)", forState: .Normal)
            customCellShopTypeButton(cell.shopTypeNameButton)
        } else {
            cell.shopTypeNameButton.setTitle("#nil", forState: .Normal)
            customCellShopTypeButton(cell.shopTypeNameButton)
        }
        
        cell.promotionTypeImageView.image = UIImage(named: "00_icon_megaphone-1")
        
        let placeholder = UIImage(named: "00_icon_people")!
        if let activitiyShopLogoImageUrl = self.activities[indexPath.row].shopImageURL {
            let URL: NSURL! = NSURL(string: activitiyShopLogoImageUrl)
            cell.shopLogoImageView?.load(URL, placeholder: placeholder)
        } else {
            cell.shopLogoImageView.image = placeholder
        }
        
        if let activityPromotionPoster = self.activities[indexPath.row].poster {
            let URL: NSURL! = NSURL(string: activityPromotionPoster)
            cell.promotionImageView?.load(URL)
        }
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
    // ------------------------------
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToPromotionDetail" {
            println("[Segue] Promotion -> Promotion Detail")
            if let indexPath = self.tableViewOutlet.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! PromotionDetailViewController
                destinationController.promotionIdSegue = self.activities[indexPath.row].promotionID
            }
        } else if segue.identifier == "SegueToShopCategory" {
            println("[Segue] Promotion -> Shop category")
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Estimote beacons configuration
    // ------------------------------
    
    func registerForLocationNotification() -> Void {
        let application: UIApplication! = UIApplication.sharedApplication()
        if (application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        }
    }
    
    func setupEstimoteBeacons() -> Void {
        println("[EstimoteBeacons] init")
        
        self.beaconManager = ESTBeaconManager()
        self.beaconManager.delegate = self
        self.beaconManager.avoidUnknownStateBeacons = true
        
        //        self.beaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"),//self.beacon.proximityUUID,
        //            major: 37470,//self.beacon.major.unsignedShortValue, // UInt16
        //            minor: 56023,//self.beacon.minor.unsignedShortValue, // UInt16
        //            identifier: "RegionIdentifier",
        //            secured: true)//self.beacon.isSecured)
        
        self.beaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"),
            identifier: "EstimoteRegion")
        
        //        println("[ESTBeaconRegion] \(self.beacon?.proximityUUID) major: \(self.beacon?.major.unsignedShortValue) minor \(self.beacon?.minor.unsignedShortValue) secured: \(self.beacon?.isSecured)")
        
        self.beaconRegion.notifyOnEntry = true//self.enterRegionSwitch.on
        self.beaconRegion.notifyOnExit = true//self.exitRegionSwitch.on
        
        self.beaconManager.startMonitoringForRegion(self.beaconRegion)
        self.beaconManager.requestStateForRegion(self.beaconRegion)
    }
    
    func switchValueChanged() -> Void {
        self.beaconManager.stopMonitoringForRegion(self.beaconRegion)
        
        self.beaconRegion.notifyOnEntry = self.enterRegionSwitch.on
        self.beaconRegion.notifyOnExit = self.exitRegionSwitch.on
        
        self.beaconManager.startMonitoringForRegion(self.beaconRegion)
    }
    
    func textForPromimity(proximity:CLProximity) -> (NSString)
    {
        var distance : NSString!
        
        switch(proximity)
        {
        case .Far:
            println("Far")
            distance = "far"
            //            beaconLabel.textColor = UIColor.redColor()
            return distance
        case .Near:
            println("Near")
            distance = "Near"
            //            beaconLabel.textColor = UIColor.purpleColor()
            return distance
        case .Immediate:
            println("Immediate")
            distance = "Immediate"
            //            beaconLabel.textColor = UIColor.greenColor()
            return distance
        case .Unknown:
            println("Unknown")
            distance = "Unknown"
            return distance
        default:
            break;
        }
        return distance
    }
    
    func startRangingBeacons() -> Void {
        if (ESTBeaconManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined) {
            if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
                // No need to explicitly request permission in iOS < 8, will happen automatically when starting ranging.
                self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
            } else if (ESTBeaconManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways) {
                self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
            } else if (ESTBeaconManager.authorizationStatus() == CLAuthorizationStatus.Denied) {
                let alertController = UIAlertController(title: "Location Access Denied",
                    message: "You have denied access to location services. Change this in app settings.",
                    preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: "Location Access Denied", style: .Cancel, handler: nil)
                alertController.addAction(confirmAction)
                presentViewController(alertController, animated: true, completion: nil)
            } else if (ESTBeaconManager.authorizationStatus() == CLAuthorizationStatus.Restricted) {
                let alertController = UIAlertController(title: "Location Access Denied",
                    message: "You have denied access to location services. Change this in app settings.",
                    preferredStyle: .Alert)
                let confirmAction = UIAlertAction(title: "Location Access Denied", style: .Cancel, handler: nil)
                alertController.addAction(confirmAction)
                presentViewController(alertController, animated: true, completion: nil)
            } else {
                /*
                * Request permission to use Location Services. (new in iOS 8)
                * We ask for "always" authorization so that the Notification Demo can benefit as well.
                * Also requires NSLocationAlwaysUsageDescription in Info.plist file.
                *
                * For more details about the new Location Services authorization model refer to:
                * https://community.estimote.com/hc/en-us/articles/203393036-Estimote-SDK-and-iOS-8-Location-Services
                */
                
                self.beaconManager.requestAlwaysAuthorization()
            }
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: ESTBeaconManager delegate
    // ------------------------------
    
    func beaconManager(manager: ESTBeaconManager!, rangingBeaconsDidFailForRegion region: ESTBeaconRegion!, withError error: NSError!) {
        let alertController = UIAlertController(title: "Ranging error", message: error.localizedDescription, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        //        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func beaconManager(manager: ESTBeaconManager!, monitoringDidFailForRegion region: ESTBeaconRegion!, withError error: NSError!) {
        let alertController = UIAlertController(title: "Monitoring error", message: error.localizedDescription, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        //        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func beaconManager(manager: ESTBeaconManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: ESTBeaconRegion!) {
        //self.beaconsArray = beacons
        //self.tableViewOutlet.reloadData()
    }
    
    func beaconManager(manager: ESTBeaconManager!, didDiscoverBeacons beacons: [AnyObject]!, inRegion region: ESTBeaconRegion!) {
        //self.beaconsArray = beacons
        //self.tableViewOutlet.reloadData()
    }
    
    func beaconManager(manager: ESTBeaconManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //        if (self.scanType == ESTScanType()) {
        //            startRangingBeacons()
        //        }
    }
    
    
    func beaconManager(manager: ESTBeaconManager!, didEnterRegion region: ESTBeaconRegion!) {
        println("[BeaconManager] didEnterRegion, region: \(region.identifier)")
        
        let notification: UILocalNotification! = UILocalNotification()
        notification.alertBody = "Hello, \(UserDefaults.sharedInstance.getUsername()) from iBeacon"//"Enter region notification"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func beaconManager(manager: ESTBeaconManager!, didExitRegion region: ESTBeaconRegion!) {
        println("[BeaconManager] didExitRegion, region: \(region.identifier)")
        
        let notification: UILocalNotification! = UILocalNotification()
        notification.alertBody = "See you again, \(UserDefaults.sharedInstance.getUsername()) from iBeacon"//"Exit region notification"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
}
