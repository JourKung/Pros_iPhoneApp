//
//  UserAuthenticationViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 8/18/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit

class UserAuthenticationViewController: BaseViewController, FBLoginViewDelegate {
    
    // MARK: -
    // MARK: Properties
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var loginView: FBLoginView!
    var userID: String!
    var userNAME: String!
    var userLINK: String!
    var userBIRTHDAY: String!
    
    // MARK: -
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loginView = FBLoginView()
        loginView.delegate = self
        loginView.readPermissions = kFacebookReadPermissions
        
        updateUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: -
    // MARK: Action
    
    
    
    // MARK: -
    // MARK: User Interface
    
    func updateUI() {
        customUI()
        customNavigationBar()
    }
    
    func customNavigationBar() {
        navigationItem.title = "Log In"
    }
    
    func customUI() {
        view.backgroundColor = UIColor(red: 28.0/255.0, green: 119.0/255.0, blue: 201.0/255.0, alpha: 1)
        
        loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 492)
        view.addSubview(loginView)
    }
    
    // MARK: -
    // MARK: Configuration
    
    // This method will be called when the user information has been fetched
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
//        println("[+] ID: " + (user.objectID))
//        println("[+] NAME: " + (user.name))
//        println("[+] LINK: " + (user.link))
//        println("[+] BIRTHDAY: " + (user.birthday))
        
        userID = user.objectID
        userNAME = user.name
        userLINK = user.link
        userBIRTHDAY = user.birthday
        
    }
    
    
    // Logged-in user experience
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("[+] View Logged In")
        performHomeViewControllerAnimated(true)
    }
    
    // Logged-out user experience
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("[+] View Logged Out")
        PFUser.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performHomeViewControllerAnimated(animated: Bool) {
        let homeVC = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as UINavigationController
//        navigationController?.presentViewController(homeVC, animated: !animated, completion: nil)
        presentViewController(homeVC, animated: !animated, completion: nil)
//        performSegueWithIdentifier("HomeViewController", sender: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        
        println("[+] ID: " + (userID))
        println("[+] NAME: " + (userNAME))
        println("[+] LINK: " + (userLINK))
        println("[+] BIRTHDAY: " + (userBIRTHDAY))
        
        if segue.identifier == "HomeViewController" {
            let destinationVC = segue.destinationViewController as HomeViewController
//            destinationVC.nameFB = userNAME
//            destinationVC.userPictureView.profileID = userID
        }
    }

}
