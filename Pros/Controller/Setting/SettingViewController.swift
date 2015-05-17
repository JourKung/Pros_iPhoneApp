//
//  SettingViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import Alamofire

class SettingViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var logoutBarButtonItem: UIBarButtonItem!
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    
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
    
    @IBAction func logoutWithFacebook(sender: AnyObject) {
        let alertController = UIAlertController(title: UserDefaults.sharedInstance.getUsername(), message: "Are you sure you want to log out of Pros?", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let logoutAction = UIAlertAction(title: "Log out", style: .Destructive) { (action) in
            NSNotificationCenter.defaultCenter().postNotificationName(LOGOUT_NOTIFICATION_KEY, object: nil)
        }
        alertController.addAction(logoutAction)
        
        presentViewController(alertController, animated: true, completion: nil)
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
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Settings")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
    }
    
    func customTableView() -> Void {
        self.tableViewOutlet.estimatedRowHeight = 80.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        self.tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
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
        NSOperationQueue.mainQueue().addOperationWithBlock({
            self.tableViewOutlet.reloadData()
            self.tableViewOutlet.stopPullToRefresh()
        })
    }

    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func userInformationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "UserInformationCell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingUserInformationTableViewCell
        
        cell.usernameLabel.text = UserDefaults.sharedInstance.getUsername()
        cell.userEmailLabel.text = UserDefaults.sharedInstance.getUserEmail()
        cell.userBirthdayLabel.text = UserDefaults.sharedInstance.getUserBirthday()
        cell.userProfileImageView.image = UIImage(data: UserDefaults.sharedInstance.getUserProfileImageData())
        
        return cell
    }
    
    func generalTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "GeneralCell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingGeneralTableViewCell
        
        return cell
    }
    
    func pushNotificationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "PushNotificationCell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingPushNotificationTableViewCell
        cell.pushNotiSwitch.setOn(true, animated: true)
        
        return cell
    }
    
    func estimoteNotificationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "EstimoteNotificationCell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingEstimoteNotificationTableViewCell
        cell.estimoteNotiSwitch.setOn(true, animated: true)
        
        return cell
    }
    
    func supportTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "SupportCell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingGeneralTableViewCell
        
        return cell
    }
    
    func privacyTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cellIdentifier = "PrivacyCell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SettingGeneralTableViewCell
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            return userInformationTableViewCell(indexPath)
        case 1:
            return generalTableViewCell(indexPath)
        case 2:
            return pushNotificationTableViewCell(indexPath)
        case 3:
            return estimoteNotificationTableViewCell(indexPath)
//        case 4:
//            return supportTableViewCell(indexPath)
//        case 5:
//            return privacyTableViewCell(indexPath)
        default:
            return UITableViewCell()
        }
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
        
        if (segue.identifier == "SegueToAbout") {
            if let indexPath = self.tableViewOutlet.indexPathForSelectedRow() {
                let destinationViewController = segue.destinationViewController as! SettingAboutViewController
            }
        }
    }
}
