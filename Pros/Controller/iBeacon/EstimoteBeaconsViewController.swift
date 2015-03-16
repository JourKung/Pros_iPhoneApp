//
//  EstimoteBeaconsViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/12/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class EstimoteBeaconsViewController: BaseViewController,
    ESTBeaconManagerDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var enterRegionSwitch: UISwitch!
    @IBOutlet weak var exitRegionSwitch: UISwitch!
    
    var beacon: ESTBeacon! = ESTBeacon()
    var beaconManager: ESTBeaconManager!
    var beaconRegion: ESTBeaconRegion!
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        println("[EstimoteBeacons] init")
//        registerForLocationNotification()
//        setupEstimoteBeacons()
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
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func registerForLocationNotification() -> Void {
        let application: UIApplication! = UIApplication.sharedApplication()
        if (application.respondsToSelector("registerUserNotificationSettings:")) {
            application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: .Alert | .Badge | .Sound, categories: nil))
        }
    }
    
    func setupEstimoteBeacons() -> Void {
        self.beaconManager = ESTBeaconManager()
        self.beaconManager.delegate = self
        
        self.beaconRegion = ESTBeaconRegion(proximityUUID: self.beacon.proximityUUID,
            major: self.beacon.major.unsignedShortValue, // UInt16
            minor: self.beacon.minor.unsignedShortValue, // UInt16
            identifier: "RegionIdentifier",
            secured: self.beacon.isSecured)
        
        self.beaconRegion.notifyOnEntry = self.enterRegionSwitch.on
        self.beaconRegion.notifyOnExit = self.exitRegionSwitch.on
    }
    
    func switchValueChanged() -> Void {
        self.beaconManager.stopMonitoringForRegion(self.beaconRegion)
        
        self.beaconRegion.notifyOnEntry = self.enterRegionSwitch.on
        self.beaconRegion.notifyOnExit = self.exitRegionSwitch.on
        
        self.beaconManager.startMonitoringForRegion(self.beaconRegion)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: ESTBeaconManager delegate
    // ------------------------------
    
    func beaconManager(manager: ESTBeaconManager!, monitoringDidFailForRegion region: ESTBeaconRegion!, withError error: NSError!) {
        let alertController = UIAlertController(title: "Monitoring error", message: error.localizedDescription, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel) { (action) in
            println("[Log] Cancel action")
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func beaconManager(manager: ESTBeaconManager!, didEnterRegion region: ESTBeaconRegion!) {
        println("[BeaconManager] didEnterRegion, region: \(region.identifier)")
        
        let notification: UILocalNotification! = UILocalNotification()
        notification.alertBody = "Enter region notification"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }
    
    func beaconManager(manager: ESTBeaconManager!, didExitRegion region: ESTBeaconRegion!) {
        println("[BeaconManager] didExitRegion, region: \(region.identifier)")
        
        let notification: UILocalNotification! = UILocalNotification()
        notification.alertBody = "Exit region notification"
        notification.soundName = UILocalNotificationDefaultSoundName
        
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    }

}
