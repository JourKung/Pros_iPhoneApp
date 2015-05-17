//
//  AppDelegate.swift
//  Pros
//
//  Created by Suwat Saegauy on 10/26/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var userAuthen: UserAuthenticationViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        /*
        NOTE: Initialze the Parse SDK
        */
        Parse.setApplicationId(kParseApplicationId, clientKey:kParseClientKey)
//        PFFacebookUtils.initializeFacebook()
        
        registerForRemoteNotificationTypes(application)
        registerForEstimoteBeacons(kEstimoteBeaconsAppId, AppToken: kEstimoteBeaconsToken)
        
        customNavigationBarOfAppearance()
        customTabbarOfAppearance()
                
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        var deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        println("[Log] Device token: \(deviceTokenString)")
        UserDefaults.sharedInstance.setUserDeviceToken(deviceTokenString)
        
        // Store the deviceToken in the current Installation and save it to Parse.
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        println("[Log] Received notification: \(userInfo)");
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError)  {
        println("[Log] Fail to register: " + error.localizedDescription)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        // Handle the user leaving the app while the Facebook login dialog is being shown
        // For example: when the user presses the iOS "home" button while the login dialog is active
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
//        PFFacebookUtils.session().close()
    }
    
    // During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
    // After authentication, your app will be called back with the session information.
    // Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        //let wasHandled: Bool = FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession:PFFacebookUtils.session())
        
        let wasHandled = FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
        
        return wasHandled
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------

    func customNavigationBarOfAppearance() -> Void {
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: true)
        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor.applicationTwitterLogoBlueColor()
    }
    
    func customTabbarOfAppearance() -> Void {
        UITabBar.appearance().barTintColor = UIColor.whiteColor()  
        UITabBar.appearance().tintColor = UIColor.applicationTwitterLogoBlueColor()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func registerForRemoteNotificationTypes(application: UIApplication!) {
        println("[Log] Device version: \(UIDevice.currentDevice().systemVersion)")
        
        let userNotificationTypes: UIUserNotificationType = .Alert | .Badge | .Sound
        let userNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(userNotificationSettings)
        application.registerForRemoteNotifications()
    }
    
    func registerForEstimoteBeacons(appID: String!, AppToken: String!) -> Void {
        // App ID and App Token should be provided using method below
        // to allow beacons connection and Estimote Cloud requests possible.
        // Both values can be found in Estimote Cloud ( http://cloud.estimote.com )
        // in Account Settings tab.
        println("ESTAppDelegate: APP ID and APP TOKEN are required to connect to your beacons and make Estimote API calls.")
        ESTConfig.setupAppID(appID, andAppToken: AppToken)
        
        // Estimote Analytics allows you to log activity related to monitoring mechanism.
        // At the current stage it is possible to log all enter/exit events when monitoring
        // Particular beacons (Proximity UUID, Major, Minor values needs to be provided).
        println("ESTAppDelegate: Analytics are turned OFF by defaults. You can enable them changing flag")
//        ESTConfig.enableAnalytics(false)
    }
}

