//
//  PromotionViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

enum ESTScanType: Int {
    case ESTScanTypeBluetooth
    case ESTScanTypeBeacon
}

class PromotionViewController: BaseTableViewController,
    ESTBeaconManagerDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------

    @IBOutlet weak var categoryBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var enterRegionSwitch: UISwitch!
    @IBOutlet weak var exitRegionSwitch: UISwitch!
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var activities: [Promotion]! = [Promotion]()
    var imageCache = [String: UIImage]()
    
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
        
        println("[EstimoteBeacons] init")
        registerForLocationNotification()
        setupEstimoteBeacons()
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
    
    func customUI() -> Void {
        customNavigationBar()
        customTableView()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Pros")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_menu-toolbar"), style: .Plain, target: self, action: "performWithShopCategoryViewControllerAnimated:")
    }
    
    func customTableView() -> Void {
        tableView.estimatedRowHeight = 180.0
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
        
        self.prosAPIClient?.getPromotionsWithCompletion().responseJSON { (request, response, results, error) -> Void in
            
            if let promotions: AnyObject = results {
                self.activities = [Promotion]()
                
                for promotion in promotions as [AnyObject] {
                    self.activities.append(Promotion(promotionID: promotion.objectForKey("promotionID") as String
                        , UserID: promotion.objectForKey("UserID") as String
                        , promotionPublishPoint: promotion.objectForKey("promotionPublishPoint") as String
                        , promotionPublishName: promotion.objectForKey("promotionPublishName") as String
                        , promotionPublishType: promotion.objectForKey("promotionPublishType") as String
                        , promotionPublishDescription: promotion.objectForKey("promotionPublishDescription") as String
                        , promotionPublishPoster: promotion.objectForKey("promotionPublishPoster") as String
                        , promotionPublishCreatedAt: promotion.objectForKey("promotionPublishCreatedAt") as String
                        , promotionPublishUpdatedAt: promotion.objectForKey("promotionPublishUpdatedAt") as String
                        , promotionPublishPublishedAt: promotion.objectForKey("promotionPublishPublishedAt") as String
                        , promotionPublishExpiredAt: promotion.objectForKey("promotionPublishExpiredAt") as String
                        , shopName: promotion.objectForKey("shopName") as String
                        , shopLogoURL: promotion.objectForKey("shopLogoURL") as String
                        , shopType: promotion.objectForKey("shopType") as String))
                   }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func performWithShopCategoryViewControllerAnimated(animated: Bool) -> Void {
        let containerShopCategoryVC = storyboard?.instantiateViewControllerWithIdentifier("ShopCategoryViewController") as UINavigationController
        
        presentViewController(containerShopCategoryVC, animated: animated, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    let cellIdentifier = "Cell"
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as PromotionTableViewCell
        
        cell.titleLabel.text = self.activities[indexPath.row].shopName
        cell.typeLabel.text = self.activities[indexPath.row].shopType
        cell.descriptionLabel.text = self.activities[indexPath.row].promotionPublishName
        
        let tmpURL = Utilities.cleanUrl(self.activities[indexPath.row].shopLogoURL)
        let image = self.imageCache[tmpURL]
        
        if (image == nil) {
            // Download an NSData representation of the image at the URL
            let urlRequest: NSURLRequest! = NSURLRequest(URL: NSURL(string: tmpURL)!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                
                if (connectionError == nil && data != nil) {
                    self.imageCache[tmpURL] = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? PromotionTableViewCell {
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
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? PromotionTableViewCell {
                    cellToUpdate.logoImageView.image = image
                }
            })
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
            
            if let indexPath = tableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as PromotionDetailViewController
                destinationController.promotionSegue = self.activities[indexPath.row]
                
                if let promotionId = self.activities[indexPath.row].promotionID {
                    println("[+] \(promotionId)")
                }
            }
        } else if (segue.identifier == "SegueToShopCategory") {
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
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert |
                UIUserNotificationType.Badge |
                UIUserNotificationType.Sound,
                categories: nil))
        }
    }
    
    func setupEstimoteBeacons() -> Void {
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
        notification.alertBody = "Welcome, \(UserDefaults.sharedInstance.getUsername())"//"Enter region notification"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func beaconManager(manager: ESTBeaconManager!, didExitRegion region: ESTBeaconRegion!) {
        println("[BeaconManager] didExitRegion, region: \(region.identifier)")
        
        let notification: UILocalNotification! = UILocalNotification()
        notification.alertBody = "Goodbye, \(UserDefaults.sharedInstance.getUsername())"//"Exit region notification"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
}
