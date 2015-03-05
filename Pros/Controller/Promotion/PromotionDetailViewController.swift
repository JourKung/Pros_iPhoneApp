//
//  PromotionDetailViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/23/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class PromotionDetailViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------

    @IBOutlet weak var tableViewOutlet: UITableView!
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
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func shareBarButtonItem(sender: AnyObject) {
        performShareViewControllerAnimated(true)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customUI() -> Void {
        customNavigationBar()
        
        self.tableViewOutlet.estimatedRowHeight = 180.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
//        self.tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        self.tableViewOutlet.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Detail")
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
    
    private func performShareViewControllerAnimated(animated: Bool) -> Void {
        let logoImage: UIImage! = UIImage(named: "00_logoDummy")
        let promotionImage: UIImage! = UIImage(named: "00_coverDummy")
        let title: String! = "Starbucks"
        let type: String! = "@Cafe"
        let detail: String! = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit."
        
        let objectsToShare: [AnyObject]! = [logoImage, promotionImage, title, type, detail]
        
        var activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        let excludedActivities = [
            //UIActivityTypeAirDrop
            //UIActivityTypePostToFacebook,
            //UIActivityTypePostToTwitter,
            UIActivityTypePostToWeibo,
            //UIActivityTypeMessage,
            //UIActivityTypeMail,
            //UIActivityTypePrint,
            //UIActivityTypeCopyToPasteboard,
            //UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
            UIActivityTypePostToFlickr,
            UIActivityTypePostToVimeo,
            UIActivityTypePostToTencentWeibo]
        
        activityViewController.excludedActivityTypes = excludedActivities
        presentViewController(activityViewController, animated: animated, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    private let cellIdentifier = "Cell"
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as PromotionDetailTableViewCell
        
        cell.title.text = "Starbucks Coffee"
        cell.type.text = "@Cafe"
        cell.detail.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim."
        cell.logoImageView.image = UIImage(named: "02_logoDummy")
        cell.promotionImageView.image = UIImage(named: "02_coverDummy")
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
