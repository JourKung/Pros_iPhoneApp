//
//  PromotionViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class PromotionViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var dummyActivities: [Promotion]?
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customUI()
        
        println("[+] \(UserDefaults.sharedInstance.getUserFbId())")
        println("[+] \(UserDefaults.sharedInstance.getUsername())")
        println("[+] \(UserDefaults.sharedInstance.getUserGender())")
        println("[+] \(UserDefaults.sharedInstance.getUserBirthday())")
        println("[+] \(UserDefaults.sharedInstance.getUserEmail())")
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
    
    private func customUI() -> Void {
        customNavigationBar()
        
        self.tableViewOutlet.estimatedRowHeight = 180.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        self.tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        self.tableViewOutlet.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Pros")
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
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
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as PromotionTableViewCell
        
        cell.title.text = "Stabucks Coffee"
        cell.type.text = "@Cafe"
        cell.detail.text = "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus."
        cell.logoImageView.image = UIImage(named: "00_logoDummy")
        cell.promotionImageView.image = UIImage(named: "00_coverDummy")
        
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
