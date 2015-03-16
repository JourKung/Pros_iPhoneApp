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
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var enterRegionSwitch: UISwitch!
    @IBOutlet weak var exitRegionSwitch: UISwitch!
    
    var beacon: ESTBeacon!
    var beaconManager: ESTBeaconManager!
    var beaconRegion: ESTBeaconRegion!
    
    var scanType: ESTScanType!
    
    var dummyActivities: [Promotion]?
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customUI()
        
        println("[+] \(UserDefaults.sharedInstance.getUserFbId())")
        println("[+] \(UserDefaults.sharedInstance.getUsername())")
        println("[+] \(UserDefaults.sharedInstance.getUserGender())")
        println("[+] \(UserDefaults.sharedInstance.getUserBirthday())")
        println("[+] \(UserDefaults.sharedInstance.getUserEmail())")
        
        println("[EstimoteBeacons] init")
        registerForLocationNotification()
        setupEstimoteBeacons()
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
    
    private func customUI() -> Void {
        customNavigationBar()
        customTableView()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Pros")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "00_menu-toolbar"), style: .Plain, target: self, action: "performWithShopCategoryViewControllerAnimated:")
    }
    
    private func customTableView() -> Void {
        tableView.estimatedRowHeight = 180.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.separatorColor = UIColor.clearColor()
        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
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
    
    func performWithShopCategoryViewControllerAnimated(animated: Bool) -> Void {
        let containerShopCategoryVC = storyboard?.instantiateViewControllerWithIdentifier("ShopCategoryViewController") as UINavigationController
        
        presentViewController(containerShopCategoryVC, animated: animated, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    private let cellIdentifier = "Cell"
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as PromotionTableViewCell
        
        cell.titleLabel.text = "Stabucks Coffee"
        cell.typeLabel.text = "@Cafe"
        cell.descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
        cell.logoImageView.image = UIImage(named: "00_logoDummy")
//        cell.promotionImageView.image = UIImage(named: "00_coverDummy")
        
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
        
        if (segue.identifier == "SegueToPromotionDetail") {
            println("[Segue] Promotion -> Promotion Detail")
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
        
        self.beaconRegion = ESTBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "EstimoteRegion")
        
        println("[ESTBeaconRegion] \(self.beacon?.proximityUUID) major: \(self.beacon?.major.unsignedShortValue) minor \(self.beacon?.minor.unsignedShortValue) secured: \(self.beacon?.isSecured)")
        
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
