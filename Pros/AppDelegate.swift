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
//    var userAuthen: UserAuthenticationViewController!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        /*
        NOTE: Initialze the Parse SDK
        */
        Parse.setApplicationId(kParseApplicationId, clientKey:kParseClientKey)
        PFFacebookUtils.initializeFacebook()
        
        registerForRemoteNotificationTypes(application)
        customNavigationBarOfAppearance()
        
        // -----
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainAuthenticationVC(storyboard)

//        let initialUserAuthenticationVC = storyboard.instantiateViewControllerWithIdentifier("UserAuthenticationViewController") as UserAuthenticationViewController
//        window?.rootViewController = initialUserAuthenticationVC
//        window?.makeKeyAndVisible()
        
        /*
        // Whenever a person opens the app, check for a cached session
        if (FBSession.activeSession().state == FBSessionState.OpenTokenExtended) {
            // If there's one, just open the session silently, without showing the user the login UI
            FBSession.openActiveSessionWithReadPermissions(kFacebookReadPermissions, allowLoginUI: false, completionHandler: {
                (session, state, error) -> Void in
                // Handler for session state changes
                // This method will be called EACH time the session state changes,
                // also for intermediate states and NOT just when the session open
                
                initialUserAuthenticationVC.sessionStateChanged(session, state: state, error: error)
            })
            
            // If there's no cached session, we will show a login button
        } else {
            initialUserAuthenticationVC.loginButton.setTitle("Log in with Facebook", forState: UIControlState.Normal)
//            self.userAuthen.performHomeViewControllerAnimated(true)
        }
        */
        return true
    }
    
    func mainHomeVC(storyboard: UIStoryboard!) -> Void {
        
    }
    
    func mainAuthenticationVC(storyboard: UIStoryboard!) -> Void {
        let initialUserAuthenticationVC = storyboard.instantiateViewControllerWithIdentifier("UserAuthenticationViewController") as UserAuthenticationViewController
        window?.rootViewController = initialUserAuthenticationVC
        window?.makeKeyAndVisible()
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        var characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        var deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        println("[Log] Device token: \(deviceTokenString)")
        
        // Store the deviceToken in the current Installation and save it to Parse.
        var currentInstallation:PFInstallation! = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
//        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError!)  {
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
        FBAppCall.handleDidBecomeActiveWithSession(PFFacebookUtils.session())
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        PFFacebookUtils.session().close()
    }
    
    // During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
    // After authentication, your app will be called back with the session information.
    // Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
        return FBAppCall.handleOpenURL(url, sourceApplication: sourceApplication, withSession: PFFacebookUtils.session())
    }

    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func registerForRemoteNotificationTypes(application:UIApplication!) {
        println("[Log] Device version: \(UIDevice.currentDevice().systemVersion)")
        
        if UIDevice.currentDevice().systemVersion >= "8.0" {
            
            var userNotificationTypes: UIUserNotificationType = UIUserNotificationType.Alert |
                UIUserNotificationType.Badge |
                UIUserNotificationType.Sound
            
            var userNotificationSettings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes: userNotificationTypes,
                categories: nil)
            
            application.registerUserNotificationSettings(userNotificationSettings)
            application.registerForRemoteNotifications()
        } else {
            /*
            NOTE: For support system version less than 8.0
            */
            application.registerForRemoteNotificationTypes(UIRemoteNotificationType.Badge |
                UIRemoteNotificationType.Sound |
                UIRemoteNotificationType.Alert)
        }
    }
    
    func customNavigationBarOfAppearance() {
        
    }
}

