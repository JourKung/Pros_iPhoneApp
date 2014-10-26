//
//  AppDelegate.swift
//  Pros
//
//  Created by Suwat Saegauy on 10/26/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        Parse.setApplicationId(kParseApplicationId, clientKey:kParseClientKey)
//        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        PFFacebookUtils.initializeFacebook()
        registerForRemoteNotificationTypes(application)
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        var deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        println("[+] DeviceToken: \(deviceTokenString)")
        
        // Store the deviceToken in the current Installation and save it to Parse.
        var currentInstallation:PFInstallation! = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        //        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!)  {
        println("[+] Fail to register: " + error.localizedDescription)
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
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
//        PFFacebookUtils.session().close()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url,
            sourceApplication:sourceApplication,
            withSession:PFFacebookUtils.session())
    }

    // MARK: -
    // MARK: Configuration
    
    func systemPrintln(message: String) {
        println("[+] System println: \(message)")
    }
    
    func registerForRemoteNotificationTypes(application:UIApplication!) {
        if UIDevice.currentDevice().systemVersion >= "8.0" {
            systemPrintln("Device version is \(UIDevice.currentDevice().systemVersion)")
            
            var userNotificationTypes: UIUserNotificationType = UIUserNotificationType.Alert |
                UIUserNotificationType.Badge |
                UIUserNotificationType.Sound
            
            var userNotificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes,
                categories: nil)
            
            application.registerUserNotificationSettings(userNotificationSettings)
            application.registerForRemoteNotifications()
        } else {
            systemPrintln("Device version is \(UIDevice.currentDevice().systemVersion)")
            
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge |
                UIRemoteNotificationType.Sound |
                UIRemoteNotificationType.Alert)
        }
    }
}

