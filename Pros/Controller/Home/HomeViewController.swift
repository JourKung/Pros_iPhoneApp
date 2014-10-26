//
//  HomeViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 8/31/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, FBLoginViewDelegate {

    // MARK: -
    // MARK: Properties
    
    @IBOutlet weak var userPictureView: FBProfilePictureView!
    @IBOutlet weak var userNameLabel: UILabel!
    var logoutView: FBLoginView!
    var nameFB: NSString!
    
    // MARK: -
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        logoutView = FBLoginView()
        logoutView.delegate = self
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
        loadData()
    }
    
    func customNavigationBar() {
//        navigationItem.title = nameFB
        //[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    }
    
    func customUI() {
        logoutView.frame = CGRectOffset(logoutView.frame, (self.view.center.x - (logoutView.frame.size.width / 2)), 492)
        view.addSubview(logoutView)
    }
    
    // MARK: -
    // MARK: Data
    
    func loadData() {
    }
    
    // MARK: -
    // MARK: Configuration
    
    // This method will be called when the user information has been fetched
    func loginViewFetchedUserInfo(loginView: FBLoginView!, user: FBGraphUser!) {
        userNameLabel.text = user.name
        userPictureView.profileID = user.objectID
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
