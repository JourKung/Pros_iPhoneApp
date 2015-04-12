//
//  NotificationDetailViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/8/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class NotificationDetailViewController: BaseTableViewController {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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
    
    @IBAction func shareBarButtonItem(sender: AnyObject) {
        performWithShareViewControllerAnimated(true)
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
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Detail")
    }
    
    private func customTableView() -> Void {
        tableView.estimatedRowHeight = 360.0
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

    private func performWithShareViewControllerAnimated(animated: Bool) -> Void {
        let logoImage: UIImage! = UIImage(named: "00_logoDummy")
        let promotionImage: UIImage! = UIImage(named: "00_coverDummy")
        let title: String! = "Starbucks"
        let type: String! = "@Cafe"
        let detail: String! = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        
        let objectsToShare: [AnyObject]! = [logoImage, promotionImage, title, type, detail]
        
        var activityViewController: UIActivityViewController! = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        let excludedActivities = [
            //UIActivityTypeAirDrop,
            //UIActivityTypePostToFacebook,
            //UIActivityTypePostToTwitter,
            //UIActivityTypeMessage,
            //UIActivityTypeMail,
            //UIActivityTypePrint,
            //UIActivityTypeCopyToPasteboard,
            UIActivityTypePostToWeibo,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo
        ]
        
        activityViewController.excludedActivityTypes = excludedActivities
        presentViewController(activityViewController, animated: animated, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    private let cellIdentifier = "Cell"
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! NotificationDetailTableViewCell
        
        cell.titleLabel.text = "Starbucks Coffee"
        cell.typeLabel.text = "@Cafe"
        cell.descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim."
        cell.logoImageView.image = UIImage(named: "00_logoDummy")
        cell.promotionImageView.image = UIImage(named: "00_coverDummy")
        cell.releasedDate.text = Utilities.dateWithString(NSDate(), dateStype: .ShortStyle, timeStyle: .NoStyle)
        cell.expiredDate.text = Utilities.dateWithString(NSDate(), dateStype: .ShortStyle, timeStyle: .NoStyle)
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
    // ------------------------------
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
