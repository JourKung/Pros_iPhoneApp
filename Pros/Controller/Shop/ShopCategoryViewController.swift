//
//  ShopCategoryViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class ShopCategoryViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var dummyActivities: [String] = [String]()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customUI()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func dismissWithCateogories(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customUI() -> Void {
        customNavigationBar()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Categories")
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        
        // This will remove extra separators from tableview
        self.tableViewOutlet.tableFooterView = UIView(frame:CGRectZero)
        self.tableViewOutlet.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    private func updateUI() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    private func loadData() -> Void {
        self.dummyActivities = ["All", "Bakery", "Bar & Bistro", "Buffet", "Cafe", "Fast food", "Restaurant"]
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
        return self.dummyActivities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as ShopCategoryTableViewCell
        cell.type.text = self.dummyActivities[indexPath.row]
        cell.typeImageView.image = UIImage(named: self.dummyActivities[indexPath.row])
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
