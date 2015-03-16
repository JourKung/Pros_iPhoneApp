//
//  SettingViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import Alamofire

class SettingViewController: BaseTableViewController {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var logoutBarButtonItem: UIBarButtonItem!
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Alamofire.request(.GET, "http://httpbin.org/get").responseJSON() {
            (_, _, data, _) in
            println(data!)
        }
        
        customUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadData()
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
    
    private func customUI() -> Void {
        customNavigationBar()
        customTableView()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Settings")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
    }
    
    private func customTableView() -> Void {
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    private func updateUI() -> Void {
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        self.refreshControl?.beginRefreshing()
        let start = CACurrentMediaTime()
        tableView.reloadData()
        refreshControl?.endRefreshing()
        println("[+] Refresh")
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    private let userInformationCellIdentifier       = "UserInformationCell"
    private let generalCellIdentifier               = "GeneralCell"
    private let pushNotificationCellIdentifier      = "PushNotificationCell"
    private let estimoteNotificationCellIdentifier  = "EstimoteNotificationCell"
    private let supportCellIdentifier               = "SupportCell"
    private let privacyCellIdentifier               = "PrivacyCell"
    
    private func userInformationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(userInformationCellIdentifier, forIndexPath: indexPath) as SettingUserInformationTableViewCell
        
        cell.usernameLabel.text = UserDefaults.sharedInstance.getUsername()
        cell.userEmailLabel.text = UserDefaults.sharedInstance.getUserEmail()
        cell.userProfileImageView.image = UIImage(data: UserDefaults.sharedInstance.getUserProfileImageData())
        
        return cell
    }
    
    private func generalTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(generalCellIdentifier, forIndexPath: indexPath) as SettingGeneralTableViewCell
        
        return cell
    }
    
    private func pushNotificationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(pushNotificationCellIdentifier, forIndexPath: indexPath) as SettingPushNotificationTableViewCell
        cell.pushNotiSwitch.setOn(true, animated: true)
        
        return cell
    }
    
    private func estimoteNotificationTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(estimoteNotificationCellIdentifier, forIndexPath: indexPath) as SettingEstimoteNotificationTableViewCell
        cell.estimoteNotiSwitch.setOn(true, animated: true)
        
        return cell
    }
    
    private func supportTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(supportCellIdentifier, forIndexPath: indexPath) as SettingGeneralTableViewCell
        
        return cell
    }
    
    private func privacyTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(privacyCellIdentifier, forIndexPath: indexPath) as SettingGeneralTableViewCell
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "SegueToAbout") {
            if let indexPath = tableView.indexPathForSelectedRow() {
                let destinationViewController = segue.destinationViewController as SettingAboutViewController
            }
        }
    }
}
